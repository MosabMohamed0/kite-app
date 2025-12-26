class AppSettingsState {
  final bool isDarkMode;
  final bool notificationsOn;

  const AppSettingsState({
    required this.isDarkMode,
    required this.notificationsOn,
  });

  AppSettingsState copyWith({
    bool? isDarkMode,
    bool? notificationsOn,
  }) {
    return AppSettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsOn: notificationsOn ?? this.notificationsOn,
    );
  }
}
