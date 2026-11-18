import '../../domain/entities/novel.dart';

class NovelModel extends Novel {
	const NovelModel({
		required super.id,
		required super.titleEnglish,
		required super.titleOriginal,
		required super.author,
		required super.status,
		required super.currentChapter,
		required super.ratingValue,
		required super.imagePlaceholder,
		super.imageUrl = '',
		super.isSaved = false,
		super.mcName = '-',
		super.mcPersonality = '-',
		super.mcAbilities = '-',
		super.worldLore = '-',
		super.nextExpectation = '-',
		super.dropReason,
	});

	factory NovelModel.fromEntity(Novel novel) => NovelModel(
				id: novel.id,
				titleEnglish: novel.titleEnglish,
				titleOriginal: novel.titleOriginal,
				author: novel.author,
				status: novel.status,
				currentChapter: novel.currentChapter,
				ratingValue: novel.ratingValue,
				imagePlaceholder: novel.imagePlaceholder,
				imageUrl: novel.imageUrl,
				isSaved: novel.isSaved,
				mcName: novel.mcName,
				mcPersonality: novel.mcPersonality,
				mcAbilities: novel.mcAbilities,
				worldLore: novel.worldLore,
				nextExpectation: novel.nextExpectation,
				dropReason: novel.dropReason,
			);

	factory NovelModel.fromMap(Map<String, dynamic> map) => NovelModel(
				id: map['id'] as String,
				titleEnglish: map['titleEnglish'] as String,
				titleOriginal: map['titleOriginal'] as String,
				author: map['author'] as String,
				status: map['status'] as String? ?? 'Reading',
				currentChapter: (map['currentChapter'] as num?)?.toInt() ?? 0,
				ratingValue: (map['ratingValue'] as num?)?.toDouble() ?? 0.0,
				imagePlaceholder: map['imagePlaceholder'] as String? ?? 'NVL',
				imageUrl: map['imageUrl'] as String? ?? '',
				isSaved: map['isSaved'] as bool? ?? false,
				mcName: map['mcName'] as String? ?? '-',
				mcPersonality: map['mcPersonality'] as String? ?? '-',
				mcAbilities: map['mcAbilities'] as String? ?? '-',
				worldLore: map['worldLore'] as String? ?? '-',
				nextExpectation: map['nextExpectation'] as String? ?? '-',
				dropReason: map['dropReason'] as String?,
			);

	Map<String, dynamic> toMap() => {
				'id': id,
				'titleEnglish': titleEnglish,
				'titleOriginal': titleOriginal,
				'author': author,
				'status': status,
				'currentChapter': currentChapter,
				'ratingValue': ratingValue,
				'imagePlaceholder': imagePlaceholder,
				'imageUrl': imageUrl,
				'isSaved': isSaved,
				'mcName': mcName,
				'mcPersonality': mcPersonality,
				'mcAbilities': mcAbilities,
				'worldLore': worldLore,
				'nextExpectation': nextExpectation,
				'dropReason': dropReason,
			};
}
