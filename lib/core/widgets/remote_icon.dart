import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Renders icons or GIFs supplied by backend URLs.
/// Includes graceful fallback if network fails or URL is empty.
class RemoteIcon extends StatelessWidget {
  const RemoteIcon({
    super.key,
    required this.url,
    this.size = 22,
    this.color,
    this.fallbackIcon = Icons.restaurant_menu,
  });

  final String? url;
  final double size;
  final Color? color;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.trim().isEmpty) {
      return Icon(fallbackIcon, size: size, color: color);
    }

    final trimmed = url!.trim();

    return CachedNetworkImage(
      imageUrl: trimmed,
      width: size,
      height: size,
      fit: BoxFit.contain,
      color: color,
      placeholder: (context, url) => SizedBox(
        width: size,
        height: size,
        child: Center(
          child: SizedBox(
            width: size * 0.6,
            height: size * 0.6,
            child: const CircularProgressIndicator(strokeWidth: 1.5),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Icon(
        fallbackIcon,
        size: size,
        color: color,
      ),
    );
  }
}
