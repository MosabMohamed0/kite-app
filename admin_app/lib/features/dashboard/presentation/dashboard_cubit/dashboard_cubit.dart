import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardState.initial());

  void changeTab(int index) {
    emit(state.copyWith(tabIndex: index));
  }

  void toggleTheme(bool isCurrentlyDark) {
    final newThemeMode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(themeMode: newThemeMode));
  }
}