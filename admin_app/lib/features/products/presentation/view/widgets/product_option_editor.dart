import 'package:admin_app/features/products/domain/models/product_option_model.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ProductOptionEditor extends StatefulWidget {
  final List<ProductOption> initialOptions;
  final Function(List<ProductOption>) onChanged;

  const ProductOptionEditor({
    super.key,
    required this.initialOptions,
    required this.onChanged,
  });

  @override
  State<ProductOptionEditor> createState() => _ProductOptionEditorState();
}

class _ProductOptionEditorState extends State<ProductOptionEditor> {
  late List<ProductOption> _options;
  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _valuesControllers = [];

  @override
  void initState() {
    super.initState();
    _options = List.from(widget.initialOptions);
    for (var option in _options) {
      _nameControllers.add(TextEditingController(text: option.name));
      _valuesControllers.add(
        TextEditingController(text: option.values.join(',')),
      );
    }
  }

  @override
  void dispose() {
    for (var c in _nameControllers) {
      c.dispose();
    }
    for (var c in _valuesControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    setState(() {
      _options.add(const ProductOption(name: '', values: []));
      _nameControllers.add(TextEditingController());
      _valuesControllers.add(TextEditingController());
    });
    _notifyParent();
  }

  void _removeOption(int index) {
    setState(() {
      _options.removeAt(index);
      _nameControllers.removeAt(index).dispose();
      _valuesControllers.removeAt(index).dispose();
    });
    _notifyParent();
  }

  void _updateOption(int index) {
    final name = _nameControllers[index].text;
    final values =
        _valuesControllers[index].text
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
    _options[index] = ProductOption(name: name, values: values);
    _notifyParent();
  }

  void _notifyParent() {
    widget.onChanged(_options);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
          Text('خيارات المنتج (مقاس، لون، ...)', style: textTheme.titleSmall),
          const SizedBox(height: 8),
          if (_options.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Text(
                  'لا توجد خيارات لهذا المنتج',
                  style: textTheme.bodySmall,
                ),
              ),
            ),

          ...List.generate(_options.length, (index) {
            return _buildOptionRow(index);
          }),

          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Iconsax.add_copy, size: 16),
            label: const Text('إضافة خيار جديد'),
            onPressed: _addOption,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionRow(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildMiniTextField(
                  controller: _nameControllers[index],
                  label: 'اسم الخيار (مثل: المقاس)',
                  onChanged: (v) => _updateOption(index),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  Iconsax.trash_copy,
                  color: Theme.of(context).colorScheme.error,
                  size: 20,
                ),
                onPressed: () => _removeOption(index),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildMiniTextField(
            controller: _valuesControllers[index],
            label: 'القيم (مثل: S,M,L)',
            onChanged: (v) => _updateOption(index),
          ),
          if (index < _options.length - 1) const Divider(height: 20),
        ],
      ),
    );
  }

  Widget _buildMiniTextField({
    required TextEditingController controller,
    required String label,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodySmall,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
