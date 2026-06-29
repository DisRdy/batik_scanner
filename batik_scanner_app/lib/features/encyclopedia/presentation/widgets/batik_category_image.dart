import 'package:flutter/material.dart';

import '../../domain/batik_category.dart';

class BatikCategoryImage extends StatelessWidget {
  const BatikCategoryImage({
    super.key,
    required this.category,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  final BatikCategory category;
  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final imageUrl = category.imageUrl.trim();
    final assetPath = batikAssetPathForName(category.name);

    if (_shouldUseAsset(imageUrl)) {
      return _AssetBatikImage(
        path: imageUrl.startsWith('assets/') ? imageUrl : assetPath,
        fit: fit,
        width: width,
        height: height,
      );
    }

    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return _AssetBatikImage(
          path: assetPath,
          fit: fit,
          width: width,
          height: height,
        );
      },
    );
  }

  bool _shouldUseAsset(String imageUrl) {
    return imageUrl.isEmpty ||
        imageUrl.startsWith('assets/') ||
        imageUrl.contains('placehold.co');
  }
}

String batikAssetPathForName(String name) {
  final normalized = name.toLowerCase();
  if (normalized.contains('bali')) {
    return 'assets/images/batik/bali.jpg';
  }
  if (normalized.contains('kawung')) {
    return 'assets/images/batik/kawung.jpg';
  }
  if (normalized.contains('mega')) {
    return 'assets/images/batik/megamendung.jpg';
  }
  return 'assets/images/batik/parang.jpg';
}

class _AssetBatikImage extends StatelessWidget {
  const _AssetBatikImage({
    required this.path,
    required this.fit,
    this.width,
    this.height,
  });

  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return ColoredBox(
          color: colorScheme.secondaryContainer,
          child: Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: colorScheme.onSecondaryContainer,
              size: 42,
            ),
          ),
        );
      },
    );
  }
}
