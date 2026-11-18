import '../entities/novel.dart';
import '../repositories/novel_repository.dart';

class NovelService {
  final NovelRepository _repository;

  NovelService(this._repository);

  NovelRepository get repository => _repository;

  Future<List<Novel>> getSortedNovels() async {
    final novels = await _repository.getNovels();
    final sorted = List<Novel>.from(novels)
      ..sort(
        (a, b) => a.titleEnglish.toLowerCase().compareTo(
          b.titleEnglish.toLowerCase(),
        ),
      );
    return sorted;
  }

  Future<List<Novel>> getNovels() => _repository.getNovels();

  Future<void> saveNovel(Novel novel) async {
    _validateNovel(novel);

    final currentNovels = await _repository.getNovels();
    final exists = currentNovels.any((item) => item.id == novel.id);
    if (exists) {
      await _repository.updateNovel(novel);
    } else {
      await _repository.addNovel(novel);
    }
  }

  Future<void> addNovel(Novel novel) async {
    _validateNovel(novel);
    await _repository.addNovel(novel);
  }

  Future<void> updateNovel(Novel novel) async {
    _validateNovel(novel);
    await _repository.updateNovel(novel);
  }

  Future<void> deleteNovel(String id) async {
    await _repository.deleteNovel(id);
  }

  Future<void> toggleBookmark(String id) async {
    await _repository.toggleBookmark(id);
  }

  void _validateNovel(Novel novel) {
    if (novel.titleEnglish.trim().isEmpty) {
      throw Exception('Judul novel tidak boleh kosong.');
    }
    if (novel.currentChapter < 0) {
      throw Exception('Bab saat ini tidak boleh negatif.');
    }
    if (!novel.ratingValue.isFinite ||
        novel.ratingValue < 0 ||
        novel.ratingValue > 5) {
      throw Exception('Rating harus berada antara 0 dan 5.');
    }
  }
}
