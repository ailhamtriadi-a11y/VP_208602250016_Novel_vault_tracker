import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/novel.dart';
import '../viewmodels/novel_form_viewmodel.dart';

class AddEditLogScreen extends StatefulWidget {
  final Novel? novelToEdit;
  const AddEditLogScreen({super.key, this.novelToEdit});

  @override
  State<AddEditLogScreen> createState() => _AddEditLogScreenState();
}

class _AddEditLogScreenState extends State<AddEditLogScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleEng;
  late final TextEditingController _titleOrig;
  late final TextEditingController _author;
  late final TextEditingController _chapter;
  late final TextEditingController _rating;
  late final TextEditingController _mcName;
  late final TextEditingController _mcPersonality;
  late final TextEditingController _mcAbilities;
  late final TextEditingController _lore;
  late final TextEditingController _nextExpectation;
  late final TextEditingController _dropReason;

  late final NovelFormViewModel _viewModel;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final item = widget.novelToEdit;
    _viewModel = NovelFormViewModel(novelToEdit: item);

    _titleEng = TextEditingController(text: item?.titleEnglish ?? '');
    _titleOrig = TextEditingController(text: item?.titleOriginal ?? '');
    _author = TextEditingController(text: item?.author ?? '');
    _chapter = TextEditingController(text: item != null ? '${item.currentChapter}' : '1');
    _rating = TextEditingController(text: item != null ? '${item.ratingValue}' : '4.5');
    _mcName = TextEditingController(text: item?.mcName == '-' ? '' : (item?.mcName ?? ''));
    _mcPersonality = TextEditingController(
      text: item?.mcPersonality == '-' ? '' : (item?.mcPersonality ?? ''),
    );
    _mcAbilities = TextEditingController(
      text: item?.mcAbilities == '-' ? '' : (item?.mcAbilities ?? ''),
    );
    _lore = TextEditingController(text: item?.worldLore == '-' ? '' : (item?.worldLore ?? ''));
    _nextExpectation = TextEditingController(
      text: item?.nextExpectation == '-' ? '' : (item?.nextExpectation ?? ''),
    );
    _dropReason = TextEditingController(text: item?.dropReason ?? '');
  }

  @override
  void dispose() {
    for (final c in [
      _titleEng,
      _titleOrig,
      _author,
      _chapter,
      _rating,
      _mcName,
      _mcPersonality,
      _mcAbilities,
      _lore,
      _nextExpectation,
      _dropReason,
    ]) {
      c.dispose();
    }
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _pickRealLocalFile() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64String = base64Encode(bytes);

        if (!mounted) return;
        _viewModel.setImage(
          fileName: image.name,
          dataUrl: 'data:image/png;base64,$base64String',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memilih gambar: $e')),
        );
      }
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final title = _titleEng.text.trim();
      final placeholder = title.length >= 3 ? title.substring(0, 3).toUpperCase() : 'NVL';

      final novelResult = Novel(
        id: widget.novelToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        titleEnglish: title,
        titleOriginal: _titleOrig.text.trim(),
        author: _author.text.trim(),
        status: _viewModel.selectedStatus,
        currentChapter: int.tryParse(_chapter.text) ?? 1,
        ratingValue: double.tryParse(_rating.text) ?? 4.0,
        imagePlaceholder: placeholder,
        imageUrl: _viewModel.imageDataUrl,
        isSaved: widget.novelToEdit?.isSaved ?? false,
        mcName: _mcName.text.trim().isEmpty ? '-' : _mcName.text.trim(),
        mcPersonality: _mcPersonality.text.trim().isEmpty ? '-' : _mcPersonality.text.trim(),
        mcAbilities: _mcAbilities.text.trim().isEmpty ? '-' : _mcAbilities.text.trim(),
        worldLore: _lore.text.trim().isEmpty ? '-' : _lore.text.trim(),
        nextExpectation: _nextExpectation.text.trim().isEmpty ? '-' : _nextExpectation.text.trim(),
        dropReason: _viewModel.selectedStatus == 'Dropped' &&
                _dropReason.text.trim().isNotEmpty
            ? _dropReason.text.trim()
            : null,
      );

      Navigator.pop(context, novelResult);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.novelToEdit != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Log' : 'Tambah Log'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleEng,
                decoration: const InputDecoration(
                  labelText: 'Judul Inggris *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleOrig,
                decoration: const InputDecoration(
                  labelText: 'Judul Asli *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _author,
                decoration: const InputDecoration(
                  labelText: 'Penulis *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              AnimatedBuilder(
                animation: _viewModel,
                builder: (context, _) => Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickRealLocalFile,
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Pilih File Gambar Asli'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _viewModel.selectedFileName.isEmpty
                                ? 'Belum ada file'
                                : _viewModel.selectedFileName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              AnimatedBuilder(
                animation: _viewModel,
                builder: (context, _) => Column(
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _viewModel.selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Reading', 'Completed', 'Plan to Read', 'Dropped']
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) _viewModel.selectStatus(value);
                      },
                    ),
                    if (_viewModel.selectedStatus == 'Dropped') ...[
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _dropReason,
                        decoration: const InputDecoration(
                          labelText: 'Alasan Drop',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _chapter,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Chapter',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final chapter = int.tryParse(value ?? '');
                        return chapter == null || chapter < 0
                            ? 'Bab harus berupa bilangan bulat nol atau lebih.'
                            : null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _rating,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Rating',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final rating = double.tryParse(value ?? '');
                        return rating == null ||
                                !rating.isFinite ||
                                rating < 0 ||
                                rating > 5
                            ? 'Rating harus berada antara 0 dan 5.'
                            : null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _mcName,
                decoration: const InputDecoration(
                  labelText: 'Nama MC',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _mcPersonality,
                decoration: const InputDecoration(
                  labelText: 'Kepribadian MC',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _mcAbilities,
                decoration: const InputDecoration(
                  labelText: 'Kemampuan MC',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lore,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Setting & Lore',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nextExpectation,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Ekspektasi Cerita Selanjutnya',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _saveForm,
                icon: const Icon(Icons.save),
                label: Text(isEdit ? 'Simpan' : 'Tambah Log'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}