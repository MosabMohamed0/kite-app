import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class InstructionEditor extends StatefulWidget {
  final List<String> initialInstructions;
  final Function(List<String>) onChanged;

  const InstructionEditor({
    super.key,
    required this.initialInstructions,
    required this.onChanged,
  });

  @override
  State<InstructionEditor> createState() => _InstructionEditorState();
}

class _InstructionEditorState extends State<InstructionEditor> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers =
        widget.initialInstructions
            .map((inst) => TextEditingController(text: inst))
            .toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addInstruction() {
    setState(() {
      _controllers.add(TextEditingController());
    });
    _notifyParent();
  }

  void _removeInstruction(int index) {
    setState(() {
      _controllers.removeAt(index).dispose();
    });
    _notifyParent();
  }

  void _notifyParent() {
    final instructions =
        _controllers
            .map((c) => c.text.trim())
            .where((s) => s.isNotEmpty)
            .toList();
    widget.onChanged(instructions);
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
          Text('Instructions', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          if (_controllers.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Text(
                  'No instructions added.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ...List.generate(_controllers.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMiniTextField(
                      controller: _controllers[index],
                      label: 'Instruction #${index + 1}',
                      onChanged: (v) => _notifyParent(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Iconsax.trash_copy,
                      color: Theme.of(context).colorScheme.error,
                      size: 20,
                    ),
                    onPressed: () => _removeInstruction(index),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Iconsax.add_copy, size: 16),
            label: const Text('Add Instruction'),
            onPressed: _addInstruction,
          ),
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
