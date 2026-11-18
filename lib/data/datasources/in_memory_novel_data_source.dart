import 'novel_data_source.dart';
import '../models/novel_model.dart';

class InMemoryNovelDataSource implements NovelDataSource {
  final List<NovelModel> _storage;

    InMemoryNovelDataSource({List<NovelModel>? initialData})
      : _storage = List<NovelModel>.from(initialData ?? const []);

  @override
  Future<List<NovelModel>> getNovels() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return List<NovelModel>.unmodifiable(_storage);
  }

  @override
  Future<void> saveNovels(List<NovelModel> novels) async {
    await Future<void>.delayed(const Duration(milliseconds: 30));
    _storage
      ..clear()
      ..addAll(novels);
  }
}