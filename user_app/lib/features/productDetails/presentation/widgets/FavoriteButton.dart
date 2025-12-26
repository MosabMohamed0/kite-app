import 'package:depi_app/core/cubit/FavoritesCubit/favorites_cubit.dart';
import 'package:depi_app/core/cubit/FavoritesCubit/favorites_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteButton extends StatelessWidget {
  final String productId;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? size;

  const FavoriteButton({
    super.key,
    required this.productId,
    this.activeColor,
    this.inactiveColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        if (state.loading) {
          return SizedBox(
            width: size ?? 24,
            height: size ?? 24,
            child: const CircularProgressIndicator(strokeWidth: 2),
          );
        }

        bool isFavorite = state.favorites.contains(productId);

        return GestureDetector(
          onTap: () {
            context.read<FavoritesCubit>().toggleFavorite(productId);
          },
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite
                ? (activeColor ?? Colors.red)
                : (inactiveColor ?? Colors.grey),
            size: size ?? 24,
          ),
        );
      },
    );
  }
}
