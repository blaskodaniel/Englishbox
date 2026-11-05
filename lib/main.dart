import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'data/providers.dart';
import 'services/reminder_service.dart';

void main() {
  runApp(const ProviderScope(child: EnglishboxApp()));
}

class EnglishboxApp extends ConsumerStatefulWidget {
  const EnglishboxApp({super.key});

  @override
  ConsumerState<EnglishboxApp> createState() => _EnglishboxAppState();
}

class _EnglishboxAppState extends ConsumerState<EnglishboxApp> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Az emlékeztetők újraütemezése, ha változik a beállítás vagy ma már
    // tanultál – mint egy `useEffect` a [reminderPlanProvider] értékére.
    ref.listenManual(reminderPlanProvider, (_, plan) {
      if (plan == null) return;
      ref
          .read(reminderServiceProvider)
          .sync(
            enabled: plan.enabled,
            minutesOfDay: plan.minutes,
            practisedToday: plan.practisedToday,
          );
    }, fireImmediately: true);

    // Éjfél után új nap: frissül a „ma”, vele a streak és az emlékeztető is.
    _lifecycle = AppLifecycleListener(
      onResume: () => ref.read(currentDayProvider.notifier).refresh(),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Englishbox',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: appRouter,
    );
  }
}
