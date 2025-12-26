import 'package:equatable/equatable.dart';

class ProductOption extends Equatable {
  final String name;
  final List<String> values;

  const ProductOption({required this.name, required this.values});

  @override
  List<Object?> get props => [name, values];

  ProductOption copyWith({String? name, List<String>? values}) {
    return ProductOption(
      name: name ?? this.name,
      values: values ?? this.values,
    );
  }
}
