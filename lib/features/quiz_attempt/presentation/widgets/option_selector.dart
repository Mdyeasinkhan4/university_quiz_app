import 'package:flutter/material.dart';

class OptionSelector extends StatelessWidget {
  final List<String> options;
  final int? selectedIndex;
  final ValueChanged<int> onSelected;

  const OptionSelector({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final isSelected = selectedIndex == index;
        const labels = ['A', 'B', 'C', 'D'];

        return InkWell(
          onTap: () => onSelected(index),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? theme.colorScheme.primaryContainer.withOpacity(0.6) : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withOpacity(0.4),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    options[index],
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary),
              ],
            ),
          ),
        );
      },
    );
  }
}
