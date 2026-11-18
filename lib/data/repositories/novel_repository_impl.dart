import '../../domain/entities/novel.dart';
import '../../domain/repositories/novel_repository.dart';
import '../datasources/novel_data_source.dart';
import '../models/novel_model.dart';

class NovelRepositoryImpl implements NovelRepository {
  final NovelDataSource dataSource;

  NovelRepositoryImpl({required this.dataSource});

  @override
  Future<List<Novel>> getNovels() async {
    final models = await dataSource.getNovels();
    return List<Novel>.unmodifiable(models);
  }

  @override
  Future<void> addNovel(Novel novel) async {
    final current = await dataSource.getNovels();
    final updated = [NovelModel.fromEntity(novel), ...current];
    await dataSource.saveNovels(updated);
  }

  @override
  Future<void> updateNovel(Novel novel) async {
    final current = await dataSource.getNovels();
    final updated = current
        .map((item) => item.id == novel.id ? NovelModel.fromEntity(novel) : item)
        .toList();
    await dataSource.saveNovels(updated);
  }

  @override
  Future<void> deleteNovel(String id) async {
    final current = await dataSource.getNovels();
    final updated = current.where((item) => item.id != id).toList();
    await dataSource.saveNovels(updated);
  }

  @override
  Future<void> toggleBookmark(String id) async {
    final current = await dataSource.getNovels();
    final updated = current.map((item) {
      if (item.id == id) {
        return NovelModel.fromEntity(item.copyWith(isSaved: !item.isSaved));
      }
      return item;
    }).toList();
    await dataSource.saveNovels(updated);
  }
}