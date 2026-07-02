import 'package:flutter/material.dart';

import '../../../../core/constants/tag_icons.dart';
import '../../../../models/muhasabah_tag.dart';

class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.tag, required this.onTap});

  final MuhasabahTag tag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isPositive = tag.kind == TagKind.positive;
    final color = isPositive
        ? const Color(0xFFA77B43)
        : const Color(0xFFB5613F);
    final icon = tagIconFor(tag.iconCodePoint,
        fallback:
            isPositive ? Icons.check_circle_outline : Icons.cancel_outlined);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                tag.name,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${tag.score > 0 ? '+' : ''}${tag.score}',
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
