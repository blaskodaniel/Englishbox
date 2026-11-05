import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/backup_service.dart';
import '../../data/db.dart';
import '../../data/providers.dart';
import '../../domain/days.dart';

/// Mentés: JSON fájl az ideiglenes mappába, majd a rendszer megosztás-ablaka
/// (Drive, Fájlok, e-mail…).
Future<void> exportBackup(BuildContext context, WidgetRef ref) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    final json = await ref.read(backupServiceProvider).exportJson();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/englishbox-backup-${dayKey(DateTime.now())}.json');
    await file.writeAsString(json);

    final result = await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'application/json')],
        subject: 'Englishbox backup',
      ),
    );
    if (result.status == ShareResultStatus.dismissed) return;

    await ref
        .read(settingsRepositoryProvider)
        .update(AppSettingsCompanion(lastBackupAt: Value(DateTime.now())));
    messenger.showSnackBar(const SnackBar(content: Text('Backup saved')));
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text('Backup failed: $e')));
  }
}

/// Visszaállítás: fájl kiválasztása, ellenőrzés, megerősítés, csere.
Future<void> importBackup(BuildContext context, WidgetRef ref) async {
  final messenger = ScaffoldMessenger.of(context);
  final service = ref.read(backupServiceProvider);
  try {
    final files = await FilePicker.pickFiles(dialogTitle: 'Choose an Englishbox backup');
    if (files.isEmpty) return;
    final json = utf8.decode(await files.first.readAsBytes());
    final count = service.countItems(json);

    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Replace your box?'),
        content: Text(
          'This backup has ${count == 1 ? '1 item' : '$count items'}. '
          'Everything currently on this phone – items, progress, XP and settings – '
          'will be replaced by the backup.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Replace')),
        ],
      ),
    );
    if (confirmed != true) return;

    await service.importJson(json);
    messenger.showSnackBar(
      SnackBar(content: Text('Restored ${count == 1 ? '1 item' : '$count items'}')),
    );
  } on BackupFormatException catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(e.message)));
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text('Restore failed: $e')));
  }
}

/// „today”, „yesterday”, „3 days ago”, „never”
String lastBackupLabel(DateTime? at, DateTime now) {
  if (at == null) return 'Never backed up';
  final days = dayNumber(now) - dayNumber(at);
  return switch (days) {
    <= 0 => 'Last backup: today',
    1 => 'Last backup: yesterday',
    _ => 'Last backup: $days days ago',
  };
}
