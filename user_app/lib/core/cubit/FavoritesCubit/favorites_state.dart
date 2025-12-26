class FavoritesState {
  final Set<String> favorites;
  final bool loading;

  const FavoritesState({
    required this.favorites,
    this.loading = false,
  });
}
