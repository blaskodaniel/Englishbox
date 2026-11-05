import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/db.dart';

/// A gyűjtemények választható ikonjai. Az adatbázisba a kulcs kerül
/// (pl. „book”), nem maga az ikon – mint egy ikonnév egy React ikonkönyvtárban.
const collectionIcons = <String, IconData>{
  'book': Icons.menu_book_outlined,
  'work': Icons.work_outline_rounded,
  'film': Icons.movie_outlined,
  'chat': Icons.chat_bubble_outline_rounded,
  'travel': Icons.flight_takeoff_rounded,
  'school': Icons.school_outlined,
  'music': Icons.music_note_outlined,
  'tech': Icons.code_rounded,
  'heart': Icons.favorite_border_rounded,
  'star': Icons.star_outline_rounded,
};

/// A választható színek – az app saját palettájából.
const collectionColors = <Color>[
  AppColors.phrase,
  AppColors.word,
  AppColors.wrong,
  AppColors.sentence,
  AppColors.rule,
  AppColors.accent,
];

IconData collectionIcon(String key) => collectionIcons[key] ?? Icons.menu_book_outlined;

/// Az ikon mögötti sötét háttér a színből (mint a terv `#221A3A` / `#10233A` dobozai).
Color collectionBackground(Color color) => Color.lerp(color, AppColors.background, 0.82)!;

extension CollectionColor on Collection {
  Color get colorValue => Color(color);
}

/// Négyzetes, lekerekített ikondoboz a gyűjtemény színével.
class CollectionBadge extends StatelessWidget {
  const CollectionBadge({super.key, required this.icon, required this.color, this.size = 48});

  final String icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: collectionBackground(color),
        borderRadius: BorderRadius.circular(size / 3),
      ),
      child: Icon(collectionIcon(icon), size: size / 2, color: color),
    );
  }
}
