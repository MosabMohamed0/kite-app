import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_settings_state.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit()
      : super(const AppSettingsState(isDarkMode: false, notificationsOn: true)) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    emit(state.copyWith(
      isDarkMode: prefs.getBool('isDarkMode') ?? false,
      notificationsOn: prefs.getBool('notificationsOn') ?? true,
    ));
  }

  Future<void> toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    emit(state.copyWith(isDarkMode: value));
  }

  Future<void> toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsOn', value);
    emit(state.copyWith(notificationsOn: value));
  }
}
