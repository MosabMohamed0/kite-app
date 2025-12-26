import 'package:admin_app/features/products/domain/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class StockEditor extends StatefulWidget {
  final ProductAttributeType attributeType;
  final Map<String, dynamic> initialStock;
  final Function(Map<String, dynamic>) onChanged;

  const StockEditor({
    super.key,
    required this.attributeType,
    required this.initialStock,
    required this.onChanged,
  });

  @override
  State<StockEditor> createState() => _StockEditorState();
}

class _StockEditorState extends State<StockEditor> {
  late TextEditingController _totalStockController;
  late List<TextEditingController> _keyControllers;
  late List<TextEditingController> _valueControllers;
  late List<TextEditingController> _colorControllers;
  late List<List<TextEditingController>> _sizeKeyControllers;
  late List<List<TextEditingController>> _sizeValueControllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void didUpdateWidget(covariant StockEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.attributeType != widget.attributeType) {
      _disposeControllers();
      _initializeControllers();
    }
  }

  void _initializeControllers() {
    _totalStockController = TextEditingController();
    _keyControllers = [];
    _valueControllers = [];
    _colorControllers = [];
    _sizeKeyControllers = [];
    _sizeValueControllers = [];

    switch (widget.attributeType) {
      case ProductAttributeType.none:
        _totalStockController.text =
            (widget.initialStock['total'] ?? 0).toString();
        break;
      case ProductAttributeType.size:
      case ProductAttributeType.color:
        widget.initialStock.forEach((key, value) {
          _keyControllers.add(TextEditingController(text: key));
          _valueControllers.add(TextEditingController(text: value.toString()));
        });
        break;
      case ProductAttributeType.both:
        widget.initialStock.forEach((colorKey, sizeMap) {
          _colorControllers.add(TextEditingController(text: colorKey));
          final nestedKeys = <TextEditingController>[];
          final nestedValues = <TextEditingController>[];
          (sizeMap as Map<String, dynamic>).forEach((sizeKey, stock) {
            nestedKeys.add(TextEditingController(text: sizeKey));
            nestedValues.add(TextEditingController(text: stock.toString()));
          });
          _sizeKeyControllers.add(nestedKeys);
          _sizeValueControllers.add(nestedValues);
        });
        break;
    }
  }

  void _disposeControllers() {
    _totalStockController.dispose();
    for (var c in _keyControllers) c.dispose();
    for (var c in _valueControllers) c.dispose();
    for (var c in _colorControllers) c.dispose();
    for (var list in _sizeKeyControllers) for (var c in list) c.dispose();
    for (var list in _sizeValueControllers) for (var c in list) c.dispose();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _notifyParent() {
    Map<String, dynamic> newStock = {};
    switch (widget.attributeType) {
      case ProductAttributeType.none:
        newStock['total'] = int.tryParse(_totalStockController.text) ?? 0;
        break;
      case ProductAttributeType.size:
      case ProductAttributeType.color:
        for (int i = 0; i < _keyControllers.length; i++) {
          final key = _keyControllers[i].text.trim();
          final value = int.tryParse(_valueControllers[i].text) ?? 0;
          if (key.isNotEmpty) newStock[key] = value;
        }
        break;
      case ProductAttributeType.both:
        for (int i = 0; i < _colorControllers.length; i++) {
          final colorKey = _colorControllers[i].text.trim();
          if (colorKey.isNotEmpty) {
            Map<String, int> sizeMap = {};
            for (int j = 0; j < _sizeKeyControllers[i].length; j++) {
              final sizeKey = _sizeKeyControllers[i][j].text.trim();
              final stockValue =
                  int.tryParse(_sizeValueControllers[i][j].text) ?? 0;
              if (sizeKey.isNotEmpty) sizeMap[sizeKey] = stockValue;
            }
            newStock[colorKey] = sizeMap;
          }
        }
        break;
    }
    widget.onChanged(newStock);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stock & Variants',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          _buildEditor(),
        ],
      ),
    );
  }

  Widget _buildEditor() {
    switch (widget.attributeType) {
      case ProductAttributeType.none:
        return _buildNoneEditor();
      case ProductAttributeType.size:
        return _buildSingleVariantEditor('Size', 'e.g., S, M');
      case ProductAttributeType.color:
        return _buildSingleVariantEditor('Color', 'e.g., Red');
      case ProductAttributeType.both:
        return _buildBothEditor();
    }
  }

  Widget _buildNoneEditor() {
    return TextFormField(
      controller: _totalStockController,
      decoration: InputDecoration(
        labelText: 'Total Quantity',
        prefixIcon: const Icon(Iconsax.archive_book_copy),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (v) => _notifyParent(),
    );
  }

  Widget _buildSingleVariantEditor(String keyName, String keyHint) {
    return Column(
      children: [
        ...List.generate(_keyControllers.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildMiniTextField(
                    controller: _keyControllers[index],
                    label: keyName,
                    hint: keyHint,
                    onChanged: (v) => _notifyParent(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: _buildMiniTextField(
                    controller: _valueControllers[index],
                    label: 'Qty',
                    hint: '0',
                    isNumber: true,
                    onChanged: (v) => _notifyParent(),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Iconsax.trash_copy,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () {
                    setState(() {
                      _keyControllers.removeAt(index).dispose();
                      _valueControllers.removeAt(index).dispose();
                    });
                    _notifyParent();
                  },
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          icon: const Icon(Iconsax.add_copy, size: 16),
          label: Text('Add $keyName'),
          onPressed: () {
            setState(() {
              _keyControllers.add(TextEditingController());
              _valueControllers.add(TextEditingController());
            });
          },
        ),
      ],
    );
  }

  Widget _buildBothEditor() {
    return Column(
      children: [
        ...List.generate(_colorControllers.length, (colorIndex) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildMiniTextField(
                        controller: _colorControllers[colorIndex],
                        label: 'Color',
                        hint: 'e.g., Red',
                        onChanged: (v) => _notifyParent(),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Iconsax.trash_copy,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () {
                        setState(() {
                          _colorControllers.removeAt(colorIndex).dispose();
                          for (var c in _sizeKeyControllers[colorIndex])
                            c.dispose();
                          for (var c in _sizeValueControllers[colorIndex])
                            c.dispose();
                          _sizeKeyControllers.removeAt(colorIndex);
                          _sizeValueControllers.removeAt(colorIndex);
                        });
                        _notifyParent();
                      },
                    ),
                  ],
                ),
                const Divider(height: 16),
                ...List.generate(_sizeKeyControllers[colorIndex].length, (
                  sizeIndex,
                ) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildMiniTextField(
                            controller:
                                _sizeKeyControllers[colorIndex][sizeIndex],
                            label: 'Size',
                            hint: 'S, M',
                            onChanged: (v) => _notifyParent(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: _buildMiniTextField(
                            controller:
                                _sizeValueControllers[colorIndex][sizeIndex],
                            label: 'Qty',
                            hint: '0',
                            isNumber: true,
                            onChanged: (v) => _notifyParent(),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _sizeKeyControllers[colorIndex]
                                  .removeAt(sizeIndex)
                                  .dispose();
                              _sizeValueControllers[colorIndex]
                                  .removeAt(sizeIndex)
                                  .dispose();
                            });
                            _notifyParent();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Iconsax.minus_cirlce_copy,
                              color: Theme.of(context).colorScheme.error,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                OutlinedButton.icon(
                  icon: const Icon(Iconsax.add_copy, size: 14),
                  label: const Text('Add Size'),
                  onPressed: () {
                    setState(() {
                      _sizeKeyControllers[colorIndex].add(
                        TextEditingController(),
                      );
                      _sizeValueControllers[colorIndex].add(
                        TextEditingController(),
                      );
                    });
                  },
                ),
              ],
            ),
          );
        }),
        OutlinedButton.icon(
          icon: const Icon(Iconsax.add_copy, size: 16),
          label: const Text('Add Color Group'),
          onPressed: () {
            setState(() {
              _colorControllers.add(TextEditingController());
              _sizeKeyControllers.add([]);
              _sizeValueControllers.add([]);
            });
          },
        ),
      ],
    );
  }

  Widget _buildMiniTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required Function(String) onChanged,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontSize: 10),
        labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
      style: const TextStyle(fontSize: 13),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
      onChanged: onChanged,
    );
  }
}
