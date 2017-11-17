import 'package:bookshelf/source/manga/dmzj.dart';

class Parser {
  searchBooks(List parsers, String keyword) {
    return parsers.map((parser) {
      return parser.searchBooks(keyword);
    }).toList();
  }

  getBookdetail(parser, String bid) async {
    return await parser.getBookdetail(bid);
  }

  getChaptercontent(parser, String bid, String cid) async {
    return await parser.getChaptercontent(bid, cid);
  }
}

parserSelector(List parsersName) {
  List parsers = [];
  parsersName.forEach((String parserName) {
    switch (parserName) {
      case 'manga_dmzj':
        parsers.add(new MangaDmzj());
    }
  });
  return parsers;
}
