export './base_page.dart';

import 'package:bloc/bloc.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  onTransition(Transition transition) => print(transition.toString());
}
