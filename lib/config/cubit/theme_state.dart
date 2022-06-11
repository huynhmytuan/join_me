part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  const ThemeState({required this.themeMode});
  factory ThemeState.initial() => const ThemeState(themeMode: ThemeMode.system);
  final ThemeMode themeMode;

  @override
  List<Object> get props => [themeMode];
  ThemeState copyWith({
    ThemeMode? themeMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
