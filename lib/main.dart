import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/novel_data_source.dart';
import 'data/datasources/shared_prefs_novel_data_source.dart';
import 'data/repositories/novel_repository_impl.dart';
import 'domain/repositories/novel_repository.dart';
import 'domain/services/novel_service.dart';
import 'presentation/screens/primary_screen.dart';
import 'presentation/viewmodels/novel_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final NovelDataSource dataSource = SharedPrefsNovelDataSource(
    sharedPreferences: preferences,
  );

  final NovelRepository repository = NovelRepositoryImpl(
    dataSource: dataSource,
  );

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final NovelRepository? repository;
  final NovelService? service;

  const MyApp({super.key, this.repository, this.service})
    : assert(repository != null || service != null);

  @override
  Widget build(BuildContext context) {
    final effectiveService = service ?? NovelService(repository!);

    return ChangeNotifierProvider(
      create: (_) => NovelViewModel(service: effectiveService)..loadNovels(),
      child: MaterialApp(
        title: 'Novel Vault Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFC85A32),
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFC85A32),
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const PrimaryScreen(),
      ),
    );
  }
}
