export 'package:bookshelf/blocs/app.dart';
export 'package:bookshelf/blocs/shelf.dart';
export 'package:bookshelf/blocs/search.dart';

import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  onTransition(Transition transition) => debugPrint(transition.event.toString());
}
