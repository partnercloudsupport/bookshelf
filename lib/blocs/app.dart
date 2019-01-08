import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'package:bookshelf/models/model.dart';
import 'package:bookshelf/services/parser.dart';

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
      // this.dispatch(RefreshDetailData());
      yield currentState.copyWith(
        currentDetailData: event.currentDetailData,
      );
    }
    if (event is RefreshDetailData) {
      if (currentState.currentDetailData is MangaBookModel) {
      } else if (currentState.currentDetailData is DoujinshiBookModel) {
        DoujinshiBookModel doujinshiBook = await DoujinshiSearchService()
            .getDetail(
                source: currentState.currentDetailData.source,
                bookId: currentState.currentDetailData.bookId);
        yield currentState.copyWith(
          currentDetailData: doujinshiBook,
        );
      } else if (currentState.currentDetailData is IllustrationBookModel) {}
    }
  }
}

abstract class _BlocState extends Equatable {
  _BlocState([Iterable props]) : super(props);
}

class AppBlocState extends _BlocState {
  AppBlocState({
    this.nightMode,
    this.currentThemeData,
    this.themeDataList,
    this.currentDetailData, // temp solution until named routes with params supported
  }) : super([
          nightMode,
          currentThemeData,
          themeDataList,
          currentDetailData,
        ]);

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
  String toString() => '''AppBlocState {
        nightMode: $nightMode,
        currentThemeData: $currentThemeData,
        themeDataList: $themeDataList,
        currentDetailData: $currentDetailData,
      }''';
}

abstract class _AppEvent extends Equatable {}

class UseNightMode extends _AppEvent {
  UseNightMode(this.nightMode);

  final bool nightMode;

  @override
  String toString() => 'Use NightMode';
}

class SetCurrentTheme extends _AppEvent {
  SetCurrentTheme(this.themeData);

  final ThemeData themeData;

  @override
  String toString() => 'Set Current Theme';
}

class SetThemeDataList extends _AppEvent {
  SetThemeDataList(this.themeDataList);

  final List<Map<String, ThemeData>> themeDataList;

  @override
  String toString() => 'Set ThemeData List';
}

class SetCurrentDetailData extends _AppEvent {
  SetCurrentDetailData(this.currentDetailData);

  final dynamic currentDetailData;

  @override
  String toString() => 'Set Current Detail Data';
}

class RefreshDetailData extends _AppEvent {
  RefreshDetailData();

  @override
  String toString() => 'Refresh Detail Data';
}
