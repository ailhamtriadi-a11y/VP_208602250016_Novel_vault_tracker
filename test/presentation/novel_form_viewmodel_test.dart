import 'package:flutter_test/flutter_test.dart';
import 'package:novel_vault_tracker/domain/entities/novel.dart';
import 'package:novel_vault_tracker/presentation/viewmodels/novel_form_viewmodel.dart';

void main() {
  test('new and edit forms start with the correct values', () {
    final newForm = NovelFormViewModel();
    const existingNovel = Novel(
      id: 'existing',
      titleEnglish: 'Existing Novel',
      titleOriginal: '既存小説',
      author: 'Test Author',
      status: 'Completed',
      currentChapter: 30,
      ratingValue: 4.5,
      imagePlaceholder: 'EN',
      imageUrl: 'data:image/jpeg;base64,abc',
    );
    final editForm = NovelFormViewModel(novelToEdit: existingNovel);
    addTearDown(newForm.dispose);
    addTearDown(editForm.dispose);

    expect(newForm.selectedStatus, 'Reading');
    expect(newForm.imageDataUrl, isEmpty);
    expect(editForm.selectedStatus, 'Completed');
    expect(editForm.imageDataUrl, existingNovel.imageUrl);
  });

  test('changing status notifies listeners and avoids redundant updates', () {
    final viewModel = NovelFormViewModel();
    addTearDown(viewModel.dispose);
    var notifications = 0;
    viewModel.addListener(() => notifications++);

    viewModel.selectStatus('Dropped');
    viewModel.selectStatus('Dropped');

    expect(viewModel.selectedStatus, 'Dropped');
    expect(notifications, 1);
  });

  test('selecting an image updates its filename and saved data URL', () {
    final viewModel = NovelFormViewModel();
    addTearDown(viewModel.dispose);
    var notifications = 0;
    viewModel.addListener(() => notifications++);

    viewModel.setImage(
      fileName: 'cover.jpg',
      dataUrl: 'data:image/jpeg;base64,abc',
    );

    expect(viewModel.selectedFileName, 'cover.jpg');
    expect(viewModel.imageDataUrl, 'data:image/jpeg;base64,abc');
    expect(notifications, 1);
  });
}
