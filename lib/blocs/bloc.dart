export 'package:bookshelf/blocs/app.dart';
export 'package:bookshelf/blocs/shelf.dart';
export 'package:bookshelf/blocs/search.dart';

import 'package:bloc/bloc.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  onTransition(Transition transition) => print(transition.event.toString());
}
