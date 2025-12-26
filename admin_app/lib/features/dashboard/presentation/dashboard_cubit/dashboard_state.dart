part of 'dashboard_cubit.dart';

class DashboardState extends Equatable {
  final int tabIndex;
  final ThemeMode themeMode;

  const DashboardState({
    required this.tabIndex,
    required this.themeMode,
  });

  factory DashboardState.initial() {
    return const DashboardState(
      tabIndex: 0,
      themeMode: ThemeMode.system,
    );
  }

  @override
  List<Object> get props => [tabIndex, themeMode];

  DashboardState copyWith({
    int? tabIndex,
    ThemeMode? themeMode,
  }) {
    return DashboardState(
      tabIndex: tabIndex ?? this.tabIndex,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}