import '../entities/novel.dart';

abstract class NovelRepository {
  Future<List<Novel>> getNovels();
  Future<void> addNovel(Novel novel);
  Future<void> updateNovel(Novel novel);
  Future<void> deleteNovel(String id);
  Future<void> toggleBookmark(String id);
}