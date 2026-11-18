import 'package:equatable/equatable.dart';

class Novel extends Equatable {
  final String id;
  final String titleEnglish;
  final String titleOriginal;
  final String author;
  final String status;
  final int currentChapter;
  final double ratingValue;
  final String imagePlaceholder;
  final String imageUrl;
  final bool isSaved;
  final String mcName;
  final String mcPersonality;
  final String mcAbilities;
  final String worldLore;
  final String nextExpectation;
  final String? dropReason;

  const Novel({
    required this.id,
    required this.titleEnglish,
    required this.titleOriginal,
    required this.author,
    required this.status,
    required this.currentChapter,
    required this.ratingValue,
    required this.imagePlaceholder,
    this.imageUrl = '',
    this.isSaved = false,
    this.mcName = '-',
    this.mcPersonality = '-',
    this.mcAbilities = '-',
    this.worldLore = '-',
    this.nextExpectation = '-',
    this.dropReason,
  });

  Novel copyWith({
    String? id,
    String? titleEnglish,
    String? titleOriginal,
    String? author,
    String? status,
    int? currentChapter,
    double? ratingValue,
    String? imagePlaceholder,
    String? imageUrl,
    bool? isSaved,
    String? mcName,
    String? mcPersonality,
    String? mcAbilities,
    String? worldLore,
    String? nextExpectation,
    String? dropReason,
  }) {
    return Novel(
      id: id ?? this.id,
      titleEnglish: titleEnglish ?? this.titleEnglish,
      titleOriginal: titleOriginal ?? this.titleOriginal,
      author: author ?? this.author,
      status: status ?? this.status,
      currentChapter: currentChapter ?? this.currentChapter,
      ratingValue: ratingValue ?? this.ratingValue,
      imagePlaceholder: imagePlaceholder ?? this.imagePlaceholder,
      imageUrl: imageUrl ?? this.imageUrl,
      isSaved: isSaved ?? this.isSaved,
      mcName: mcName ?? this.mcName,
      mcPersonality: mcPersonality ?? this.mcPersonality,
      mcAbilities: mcAbilities ?? this.mcAbilities,
      worldLore: worldLore ?? this.worldLore,
      nextExpectation: nextExpectation ?? this.nextExpectation,
      dropReason: dropReason ?? this.dropReason,
    );
  }

  @override
  List<Object?> get props => [
        id,
        titleEnglish,
        titleOriginal,
        author,
        status,
        currentChapter,
        ratingValue,
        imagePlaceholder,
        imageUrl,
        isSaved,
        mcName,
        mcPersonality,
        mcAbilities,
        worldLore,
        nextExpectation,
        dropReason,
      ];
}