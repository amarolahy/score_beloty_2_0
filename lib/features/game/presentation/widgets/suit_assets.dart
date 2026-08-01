import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/deal.dart';

class SuitAsset {
  const SuitAsset({required this.assetPath, required this.color});

  final String assetPath;
  final Color color;
}

class SuitAssets {
  SuitAssets._();

  static const SuitAsset allTrumps =
      SuitAsset(assetPath: 'assets/suits/all_trumps.svg', color: Color(0xFFFFB300));
  static const SuitAsset noTrumps =
      SuitAsset(assetPath: 'assets/suits/no_trumps.svg', color: Color(0xFF455A64));
  static const SuitAsset spades =
      SuitAsset(assetPath: 'assets/suits/spades.svg', color: Colors.black);
  static const SuitAsset hearts =
      SuitAsset(assetPath: 'assets/suits/hearts.svg', color: Color(0xFFD32F2F));
  static const SuitAsset diamonds =
      SuitAsset(assetPath: 'assets/suits/diamonds.svg', color: Color(0xFFD32F2F));
  static const SuitAsset clubs =
      SuitAsset(assetPath: 'assets/suits/clubs.svg', color: Colors.black);
  static const SuitAsset fallback =
      SuitAsset(assetPath: 'assets/suits/no_trumps.svg', color: Colors.grey);

  static SuitAsset forContract(ContractType type) {
    switch (type) {
      case ContractType.allTrumps:
        return allTrumps;
      case ContractType.noTrumps:
        return noTrumps;
      case ContractType.spades:
        return spades;
      case ContractType.hearts:
        return hearts;
      case ContractType.diamonds:
        return diamonds;
      case ContractType.clubs:
        return clubs;
      case ContractType.error:
        return fallback;
    }
  }
}

class SuitIcon extends StatelessWidget {
  const SuitIcon({
    super.key,
    required this.contract,
    this.size = 28,
  });

  final ContractType contract;
  final double size;

  @override
  Widget build(BuildContext context) {
    final suit = SuitAssets.forContract(contract);
    return SvgPicture.asset(
      suit.assetPath,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(suit.color, BlendMode.srcIn),
    );
  }
}
