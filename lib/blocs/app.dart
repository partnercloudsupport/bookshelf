import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class AppBloc extends Bloc<_AppEvent, AppBlocState> {
  @override
  AppBlocState get initialState => AppBlocState.init();

  @override
  Stream<AppBlocState> mapEventToState(
      AppBlocState currentState, _AppEvent event) async* {
    if (event is UseNightMode)
      yield currentState.copyWith(
        nightMode: event.nightMode,
      );
    if (event is SetCurrentTheme) {
      FlutterStatusbarcolor.setNavigationBarColor(
        event.themeData.primaryColor,
        animate: true,
      );
      yield currentState.copyWith(
        currentThemeData: event.themeData,
      );
    }
    if (event is SetThemeDataList)
      yield currentState.copyWith(
        themeDataList: event.themeDataList,
      );
  }
}

class AppBlocState {
  AppBlocState({
    this.nightMode,
    this.currentThemeData,
    this.themeDataList,
  });

  final bool nightMode;
  final ThemeData currentThemeData;
  final List<Map<String, ThemeData>> themeDataList;

  factory AppBlocState.init() {
    return AppBlocState(
      nightMode: false,
      currentThemeData: ThemeData(
        primaryColor: Colors.blue,
      ),
      themeDataList: [
        {
          'default': ThemeData(
            primaryColor: Colors.blue,
          ),
        }
      ],
    );
  }

  AppBlocState copyWith({
    bool nightMode,
    ThemeData currentThemeData,
    List<Map<String, ThemeData>> themeDataList,
  }) {
    return AppBlocState(
      nightMode: nightMode ?? this.nightMode,
      currentThemeData: currentThemeData ?? this.currentThemeData,
      themeDataList: themeDataList ?? this.themeDataList,
    );
  }

  @override
  bool operator ==(
    Object other,
  ) =>
      identical(
        this,
        other,
      ) ||
      other is AppBlocState &&
          runtimeType == other.runtimeType &&
          nightMode == other.nightMode &&
          currentThemeData == other.currentThemeData &&
          themeDataList == other.themeDataList;

  @override
  int get hashCode =>
      nightMode.hashCode ^ currentThemeData.hashCode ^ themeDataList.hashCode;

  @override
  String toString() =>
      'AppBlocState { nightMode: $nightMode, currentThemeData: $currentThemeData, themeDataList: $themeDataList }';
}

abstract class _AppEvent {}

class UseNightMode extends _AppEvent {
  UseNightMode(this.nightMode);

  final bool nightMode;
}

class SetCurrentTheme extends _AppEvent {
  SetCurrentTheme(this.themeData);

  final ThemeData themeData;
}

class SetThemeDataList extends _AppEvent {
  SetThemeDataList(this.themeDataList);

  final List<Map<String, ThemeData>> themeDataList;
}
