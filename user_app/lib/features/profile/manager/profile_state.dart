class ProfileState {
  final bool isDarkMode;
  final bool notificationsOn;

  ProfileState({
    required this.isDarkMode,
    required this.notificationsOn,
  });

  ProfileState copyWith({
    bool? isDarkMode,
    bool? notificationsOn,
  }) {
    return ProfileState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsOn: notificationsOn ?? this.notificationsOn,
    );
  }
}
