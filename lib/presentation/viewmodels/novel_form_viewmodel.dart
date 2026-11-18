import 'package:flutter/foundation.dart';

import '../../domain/entities/novel.dart';

class NovelFormViewModel extends ChangeNotifier {
  String _selectedStatus;
  String _selectedFileName = '';
  String _imageDataUrl;

  NovelFormViewModel({Novel? novelToEdit})
    : _selectedStatus = novelToEdit?.status ?? 'Reading',
      _imageDataUrl = novelToEdit?.imageUrl ?? '';

  String get selectedStatus => _selectedStatus;
  String get selectedFileName => _selectedFileName;
  String get imageDataUrl => _imageDataUrl;

  void selectStatus(String status) {
    if (_selectedStatus == status) return;
    _selectedStatus = status;
    notifyListeners();
  }

  void setImage({required String fileName, required String dataUrl}) {
    _selectedFileName = fileName;
    _imageDataUrl = dataUrl;
    notifyListeners();
  }
}
