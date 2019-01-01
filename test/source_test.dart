import 'dart:io';

import 'package:test_api/test_api.dart';

import 'package:bookshelf/sources/source.dart';
import 'package:bookshelf/utils/global_var.dart';

import '_token.dart';

main() {
  group('[Test nhentai source usability]', () {
    GlobalVar().tempPath = Directory.current;

    test('=> Is DoujinshiSource', () {
      expect(NHentaiSource() is DoujinshiSource, true);
    });
    test('=> Login', () async {
      expect(
          await NHentaiSource().login(nhentai['username'], nhentai['password']),
          true);
    });
    test('=> Search books', () async {
      var books = await NHentaiSource().searchBooks('ネロと気持ちいいコトしよう chinese');
      expect(books.totalPages, 1);
      expect(books.result.length, 1);
      expect(books.result[0].bookId, '219952');
      expect(books.result[0].name,
          '(C93) [Tuzi Laoda (Sayika)] Nero to Kimochi Ii Koto Shiyou (Fate/Grand Order) [Chinese] [有毒気漢化組]');
    });
    test('=> Get book details', () async {
      var book = await NHentaiSource().getBookDetail('219952');
      expect(book.bookId, '219952');
      expect(book.source is NHentaiSource, true);
      expect(book.name,
          '(C93) [Tuzi Laoda (Sayika)] Nero to Kimochi Ii Koto Shiyou (Fate/Grand Order) [Chinese] [有毒気漢化組]');
      expect(book.previewPages.length, 20);
      expect(book.pages[8], 'https://i.nhentai.net/galleries/1166614/9.jpg');
      expect(book.languages.contains('chinese'), true);
    });
    test('=> Get Favorite Books', () async {
      var books = await NHentaiSource().getFavoriteBooks();
      expect(books.length, 26);
      expect(books.last.bookId, '219952');
    });
  });

  group('[Test e-hentai source usability]', () {
    GlobalVar().tempPath = Directory.current;

    test('=> Is DoujinshiSource', () {
      expect(EHentaiSource() is DoujinshiSource, true);
    });
    test('=>Login', () {});
    test('=>Search books', () {});
    test('=>Get book details', () {});
    test('=>Get Favorite Books', () {});
  });
}
