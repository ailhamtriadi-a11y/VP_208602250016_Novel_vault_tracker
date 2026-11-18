import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/error/failure.dart';
import '../models/novel_model.dart';
import 'novel_data_source.dart';
import 'seed_novel.dart';

class SharedPrefsNovelDataSource implements NovelDataSource {
  static const String _storageKey = 'novel_vault_logs_v1';
  static const String _initializedKey = 'novel_vault_initialized_v1';

  final SharedPreferences sharedPreferences;

  SharedPrefsNovelDataSource({required this.sharedPreferences});

  @override
  Future<List<NovelModel>> getNovels() async {
    try {
      final isInitialized = sharedPreferences.getBool(_initializedKey) ?? false;
      final rawJsonList = sharedPreferences.getStringList(_storageKey);

      if (!isInitialized || rawJsonList == null) {
        final seeds = getInitialSeedNovels();
        await saveNovels(seeds);
        await sharedPreferences.setBool(_initializedKey, true);
        return seeds;
      }

      return rawJsonList
          .map((item) => NovelModel.fromMap(jsonDecode(item) as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const CacheFailure('Gagal membaca data novel dari penyimpanan lokal.');
    }
  }

  @override
  Future<void> saveNovels(List<NovelModel> novels) async {
    try {
      final encoded = novels.map((n) => jsonEncode(n.toMap())).toList();
      final success = await sharedPreferences.setStringList(_storageKey, encoded);
      if (!success) {
        throw const CacheFailure('Gagal menyimpan perubahan ke penyimpanan lokal.');
      }
    } catch (e) {
      if (e is Failure) rethrow;
      throw const CacheFailure('Terjadi gangguan saat menyimpan data ke perangkat.');
    }
  }
}