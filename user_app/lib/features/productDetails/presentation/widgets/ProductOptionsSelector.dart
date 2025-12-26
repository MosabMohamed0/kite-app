import 'package:flutter/material.dart';

class ProductOptionsSelector extends StatefulWidget {
  final String sizeColorBoth; // 'color' | 'size' | 'both'
  final Map<String, dynamic> stock;
  final void Function(String?)? onColorSelected;
  final void Function(String?)? onSizeSelected;

  const ProductOptionsSelector({
    super.key,
    required this.sizeColorBoth,
    required this.stock,
    this.onColorSelected,
    this.onSizeSelected,
  });

  @override
  State<ProductOptionsSelector> createState() => _ProductOptionsSelectorState();
}

class _ProductOptionsSelectorState extends State<ProductOptionsSelector> {
  String? selectedColor;
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    late final theme=Theme.of(context);
    final stock = widget.stock;

    switch (widget.sizeColorBoth) {
      case 'color':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text("Color", style:theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 20,
              runSpacing: 10,
              children:
                  stock.keys.map<Widget>((color) {
                    final isSelected = selectedColor == color;
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedColor = color);
                        widget.onColorSelected?.call(color);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? theme.primaryColor.withOpacity(0.5):theme.primaryColor,
                          border: Border.all(
                            color: isSelected ? theme.primaryColor.withOpacity(0.5):theme.primaryColor,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          color,
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        );

      case 'size':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text("Size", style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 20,
              runSpacing: 10,
              children:
                  stock.keys.map<Widget>((size) {
                    final isSelected = selectedSize == size;
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedSize = size);
                        widget.onSizeSelected?.call(size);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? theme.primaryColor.withOpacity(0.5):theme.primaryColor,
                          border: Border.all(
                            color: isSelected ? theme.primaryColor.withOpacity(0.5):theme.primaryColor,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(size, style: theme.textTheme.headlineSmall),
                      ),
                    );
                  }).toList(),
            ),
          ],
        );

      case 'both':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text("Color", style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 20,
              runSpacing: 10,
              children:
                  stock.keys.map<Widget>((color) {
                    final isSelected = selectedColor == color;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = color;
                          selectedSize = null;
                        });
                        widget.onColorSelected?.call(color);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected ?  theme.primaryColor.withOpacity(0.5):theme.primaryColor,
                          border: Border.all(
                            color: isSelected ? theme.primaryColor.withOpacity(0.5):theme.primaryColor,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          color,
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
            Text("Size", style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            if (selectedColor != null)
              Wrap(
                spacing: 20,
                runSpacing: 10,
                children:
                    stock[selectedColor]!.keys.map<Widget>((size) {
                      final isSelected = selectedSize == size;
                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedSize = size);
                          widget.onSizeSelected?.call(size);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected? theme.primaryColor.withOpacity(0.5):theme.primaryColor,
                            border: Border.all(
                              color:
                                  isSelected ? theme.primaryColor.withOpacity(0.5):theme.primaryColor,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            size,
                            style: theme.textTheme.headlineSmall,
                          ),
                        ),
                      );
                    }).toList(),
              )
            else
               Text(
                "Choose a color first",
                style:theme.textTheme.labelMedium?.copyWith(color: Colors.red),
              ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
