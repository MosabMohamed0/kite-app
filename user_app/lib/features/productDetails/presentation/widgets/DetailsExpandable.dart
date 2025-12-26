import 'package:flutter/material.dart';

class ProductDetailsExpandable extends StatelessWidget {
  final String description;
  final List<String> instruction;

  const ProductDetailsExpandable({
    super.key,
    required this.description,
    required this.instruction,
  });

  @override
  Widget build(BuildContext context) {
    late final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: Column(
        children: [
          ExpansionTile(
            title: Text('Description', style: theme.textTheme.titleMedium),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.01,
                ),
                child: Text(description, style: const TextStyle(height: 1.5)),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Instruction', style: theme.textTheme.titleMedium),
            children:
                instruction.map<Widget>((e) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.01,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check, size: 16, color: theme.primaryColor),
                        const SizedBox(width: 6),
                        Expanded(child: Text(e)),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
