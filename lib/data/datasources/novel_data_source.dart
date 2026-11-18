import '../models/novel_model.dart';

abstract class NovelDataSource {
  Future<List<NovelModel>> getNovels();
  Future<void> saveNovels(List<NovelModel> novels);
}