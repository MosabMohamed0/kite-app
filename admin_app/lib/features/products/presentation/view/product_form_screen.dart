import 'dart:io';
import 'package:admin_app/features/products/domain/models/review_model.dart';
import 'package:admin_app/features/products/presentation/product_cubit/product_cubit.dart';
import 'package:admin_app/features/products/presentation/view/widgets/instruction_editor_widget.dart';
import 'package:admin_app/features/products/presentation/view/widgets/stock_editor_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;

import '../../domain/models/product_model.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _brandController;
  late TextEditingController _descriptionController;
  late TextEditingController _photoUrlController;

  late String _id;
  late List<String> _instructions;
  late ProductAttributeType _attributeType;
  late Map<String, dynamic> _stock;
  String? _selectedCategory;

  File? _selectedImageFile;
  final _imagePicker = ImagePicker();
  bool _isUploading = false;

  late List<Review> _comments;
  late double _rate;
  late int _reviews;
  late Timestamp _date;

  final List<String> _generalCategories = [
    'Electronics',
    'Apparel',
    'Shoes',
    'Furniture',
    'Books',
    'Sports & Outdoors',
    'Grocery',
    'Beauty & Health',
  ];

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _id = p?.id ?? '';
    _nameController = TextEditingController(text: p?.name ?? '');
    _priceController = TextEditingController(text: p?.price.toString() ?? '');
    _brandController = TextEditingController(text: p?.brand ?? '');
    _selectedCategory = p?.category;
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _photoUrlController = TextEditingController(text: p?.photoUrl ?? '');
    _instructions = List<String>.from(p?.instruction ?? []);
    _attributeType = p?.productAttributeType ?? ProductAttributeType.none;
    _stock = Map<String, dynamic>.from(p?.stock ?? {});
    _comments = p?.comments ?? [];
    _rate = p?.rate ?? 0;
    _reviews = p?.reviews ?? 0;
    _date = p?.date ?? Timestamp.now();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _brandController.dispose();
    _descriptionController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      setState(() {
        _selectedImageFile = File(file.path);
      });
    }
  }

  Future<String?> _uploadImageToSupabase() async {
    if (_selectedImageFile == null) return null;
    setState(() => _isUploading = true);

    try {
      final fileExtension = p.extension(_selectedImageFile!.path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      final filePath = 'public/$fileName';

      await Supabase.instance.client.storage
          .from('product_images')
          .upload(
            filePath,
            _selectedImageFile!,
            fileOptions: const FileOptions(upsert: true),
          );

      final publicUrl = Supabase.instance.client.storage
          .from('product_images')
          .getPublicUrl(filePath);

      setState(() => _isUploading = false);
      return publicUrl;
    } catch (e) {
      setState(() => _isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red),
        );
      }
      return null;
    }
  }

  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_isUploading) return;

    String photoUrlToSave = _photoUrlController.text;

    if (_selectedImageFile != null) {
      final newUrl = await _uploadImageToSupabase();
      if (newUrl == null) return;
      photoUrlToSave = newUrl;
    }

    if (photoUrlToSave.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an image.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final newProduct = Product(
      id: _id,
      name: _nameController.text,
      price: double.tryParse(_priceController.text) ?? 0,
      brand: _brandController.text,
      category: _selectedCategory!,
      description: _descriptionController.text,
      photoUrl: photoUrlToSave,
      instruction: _instructions,
      productAttributeType: _attributeType,
      stock: _stock,
      comments: _comments,
      rate: _rate,
      reviews: _reviews,
      date: _date,
    );

    if (!mounted) return;

    if (_isEditing) {
      context.read<ProductCubit>().updateProduct(newProduct);
    } else {
      context.read<ProductCubit>().addProduct(newProduct);
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing ? 'Updated successfully' : 'Added successfully',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'Add New Product'),
        actions: [
          if (_isUploading)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Iconsax.save_2_copy),
              onPressed: _submitForm,
            ),
        ],
      ),
      body: IgnorePointer(
        ignoring: _isUploading,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(size.width * 0.04),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProductImagePicker(
                  selectedFile: _selectedImageFile,
                  existingUrl: _photoUrlController.text,
                  onPickImage: _pickImage,
                  isEditing: _isEditing,
                ),
                SizedBox(height: size.height * 0.02),

                _buildResponsiveTextField(
                  controller: _nameController,
                  label: 'Product Name',
                  icon: Iconsax.box_1_copy,
                ),
                _buildResponsiveTextField(
                  controller: _priceController,
                  label: 'Price (EGP)',
                  icon: Iconsax.money_copy,
                  keyboardType: TextInputType.number,
                ),
                _buildResponsiveTextField(
                  controller: _brandController,
                  label: 'Brand',
                  icon: Iconsax.building_copy,
                ),

                _buildCategoryDropdown(),
                SizedBox(height: size.height * 0.02),

                _buildResponsiveTextField(
                  controller: _descriptionController,
                  label: 'Description',
                  icon: Iconsax.document_text_copy,
                  maxLines: 4,
                ),

                InstructionEditor(
                  initialInstructions: _instructions,
                  onChanged: (updatedList) => _instructions = updatedList,
                ),
                SizedBox(height: size.height * 0.02),

                _buildAttributeSelector(),
                SizedBox(height: size.height * 0.02),

                StockEditor(
                  attributeType: _attributeType,
                  initialStock: _stock,
                  onChanged: (updatedStock) => _stock = updatedStock,
                ),

                SizedBox(height: size.height * 0.04),
                ElevatedButton.icon(
                  onPressed: _isUploading ? null : _submitForm,
                  icon: Icon(_isEditing ? Iconsax.edit_copy : Iconsax.add_copy),
                  label: Text(
                    _isUploading
                        ? 'Uploading...'
                        : (_isEditing ? 'Save Changes' : 'Add Product'),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (val) => (val?.isEmpty ?? true) ? 'Required' : null,
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Category',
        prefixIcon: const Icon(Iconsax.category_copy),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      items:
          _generalCategories
              .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
              .toList(),
      onChanged: (val) => setState(() => _selectedCategory = val),
      validator: (val) => val == null ? 'Select category' : null,
    );
  }

  Widget _buildAttributeSelector() {
    return DropdownButtonFormField<ProductAttributeType>(
      value: _attributeType,
      decoration: InputDecoration(
        labelText: 'Attribute Type',
        prefixIcon: const Icon(Iconsax.mirroring_screen_copy),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      items: const [
        DropdownMenuItem(
          value: ProductAttributeType.none,
          child: Text('None (Simple)'),
        ),
        DropdownMenuItem(
          value: ProductAttributeType.size,
          child: Text('Size Only'),
        ),
        DropdownMenuItem(
          value: ProductAttributeType.color,
          child: Text('Color Only'),
        ),
        DropdownMenuItem(
          value: ProductAttributeType.both,
          child: Text('Size & Color'),
        ),
      ],
      onChanged: (val) {
        if (val != null) {
          setState(() {
            _attributeType = val;
            _stock = {};
          });
        }
      },
    );
  }
}

class ProductImagePicker extends StatelessWidget {
  final File? selectedFile;
  final String existingUrl;
  final VoidCallback onPickImage;
  final bool isEditing;

  const ProductImagePicker({
    super.key,
    required this.selectedFile,
    required this.existingUrl,
    required this.onPickImage,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Image', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Container(
          height: size.height * 0.25,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _buildImageContent(),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: OutlinedButton.icon(
            onPressed: onPickImage,
            icon: const Icon(Iconsax.gallery_edit_copy),
            label: Text(
              selectedFile != null || existingUrl.isNotEmpty
                  ? 'Change Image'
                  : 'Select Image',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageContent() {
    if (selectedFile != null) {
      return Image.file(selectedFile!, fit: BoxFit.cover);
    }
    if (isEditing && existingUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: existingUrl,
        fit: BoxFit.cover,
        placeholder:
            (_, __) => const Center(child: CircularProgressIndicator()),
        errorWidget:
            (_, __, ___) => const Icon(Iconsax.gallery_slash, size: 50),
      );
    }
    return const Center(child: Icon(Iconsax.gallery_add, size: 50));
  }
}
