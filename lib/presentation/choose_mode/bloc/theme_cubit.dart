import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void updateTheme(ThemeMode themeMode) => emit(themeMode);

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    // // TODO: implement fromJson
    // throw UnimplementedError();
    try {
      final themeString = json['theme'] as String;
      return ThemeMode.values.firstWhere((e) => e.toString() == themeString);
    } catch (_) {
      return null; // Trường hợp không thể khôi phục trạng thái
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    // // TODO: implement toJson
    // throw UnimplementedError();
    return {
      'theme': state.toString(),
    };
  }
}
