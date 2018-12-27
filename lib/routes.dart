import 'package:flutter/material.dart';

routes(RouteSettings settings) {
  switch (settings.name) {
    case '/manga_shelf': return;
    case '/doujinshi_shelf': return;
    case '/manga_detail': return;
    case '/doujinshi_detail': return;
    case '/search': return;
    case '/about': return;
    default: return;
  }
}
