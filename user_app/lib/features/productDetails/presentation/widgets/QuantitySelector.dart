import 'package:flutter/material.dart';

class QuantitySelector extends StatefulWidget {
  final int initialQuantity;
  final int min;
  final int max;
  final Function(int)? onChanged;

  const QuantitySelector({
    super.key,
    this.initialQuantity = 1,
    this.min = 1,
    this.max = 99,
    this.onChanged,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  void increase() {
    if (quantity < widget.max) {
      setState(() {
        quantity++;
      });
      widget.onChanged?.call(quantity);
    }
  }

  void decrease() {
    if (quantity > widget.min) {
      setState(() {
        quantity--;
      });
      widget.onChanged?.call(quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    late final theme=Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: decrease, icon: const Icon(Icons.remove)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              quantity.toString(),
              style: theme.textTheme.bodyLarge,
            ),
          ),
          IconButton(onPressed: increase, icon: const Icon(Icons.add)),
        ],
      ),
    );
  }
}
