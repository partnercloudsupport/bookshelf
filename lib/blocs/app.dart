import 'package:bloc/bloc.dart';
import 'package:bookshelf/models/model.dart';
import 'package:bookshelf/services/parser.dart';
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
    if (event is SetCurrentDetailData) {
      DoujinshiBookModel doujinshiBook = await DoujinshiSearchService()
          .getDetail(
              source: event.currentDetailData.source,
              bookId: event.currentDetailData.bookId);
      yield currentState.copyWith(
        currentDetailData: doujinshiBook,
      );
    }
  }
}

class AppBlocState {
  AppBlocState({
    this.nightMode,
    this.currentThemeData,
    this.themeDataList,
    this.currentDetailData, // temp solution
  });

  final bool nightMode;
  final ThemeData currentThemeData;
  final List<Map<String, ThemeData>> themeDataList;
  final dynamic currentDetailData;

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
    dynamic currentDetailData,
  }) {
    return AppBlocState(
      nightMode: nightMode ?? this.nightMode,
      currentThemeData: currentThemeData ?? this.currentThemeData,
      themeDataList: themeDataList ?? this.themeDataList,
      currentDetailData: currentDetailData ?? this.currentDetailData,
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
          themeDataList == other.themeDataList &&
          currentDetailData == other.currentDetailData;

  @override
  int get hashCode =>
      nightMode.hashCode ^
      currentThemeData.hashCode ^
      themeDataList.hashCode ^
      currentDetailData.hashCode;

  @override
  String toString() => '''AppBlocState {
        nightMode: $nightMode,
        currentThemeData: $currentThemeData,
        themeDataList: $themeDataList,
        currentDetailData: $currentDetailData,
      }''';
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

class SetCurrentDetailData extends _AppEvent {
  SetCurrentDetailData(this.currentDetailData);

  final dynamic currentDetailData;
}
