import 'package:bookshelf/sources/source.dart';
import 'package:bookshelf/models/model.dart';

abstract class DoujinshiSource extends BaseDoujinshiSource {
  Future<bool> login(String account, String password);
  Future<List<DoujinshiBook>> getFavoriteBooks();
}
