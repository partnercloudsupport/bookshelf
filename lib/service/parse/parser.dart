import 'package:bookshelf/source/source.dart' show MangaDmzj, NovelDmzj;

class Parser {
  searchBooks(List parsers, String keyword) {
    return parsers.map((parser) {
      return parser.searchBooks(keyword);
    }).toList();
  }

  getBookDetail(parser, String bid) async {
    return await parser.getBookDetail(bid);
  }

  getChapterContent(parser, String bid, String cid, [String vid]) async {
    if (vid != null) return await parser.getChapterContent(bid, vid, cid);
    return await parser.getChapterContent(bid, cid);
  }
}

parserSelector(List parsersName) {
  Map<String, List> parsers = {'manga': [], 'novel': [], 'doujinshi': []};
  parsersName.forEach((String parserName) {
    switch (parserName) {
      case 'manga_dmzj':
        parsers['manga'].add(new MangaDmzj());
        break;
      case 'novel_dmzj':
        parsers['novel'].add(new NovelDmzj());
        break;
    }
  });
  return parsers;
}
