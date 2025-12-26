import 'package:depi_app/features/HomeScreen/presentation/widgets/categories.dart';
import 'package:flutter/material.dart';

class HorizontalCategoryButtons extends StatefulWidget {
  final Function(String) onCategorySelected;

  const HorizontalCategoryButtons({
    super.key,
    required this.onCategorySelected,
  });

  @override
  _HorizontalCategoryButtonsState createState() =>
      _HorizontalCategoryButtonsState();
}

class _HorizontalCategoryButtonsState extends State<HorizontalCategoryButtons> {
  final List<String> categories = Categories().categories;
  late final theme = Theme.of(context);

  int? selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;
    return Container(
      height: screenHeight * 0.055,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;

          Color bgColor =
              isSelected
                  ? theme.primaryColor
                  : theme.canvasColor.withOpacity(0.5);

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                widget.onCategorySelected(categories[index]);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.01,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    categories[index],
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
