import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure([
    super.message = 'Gagal memuat atau menyimpan data novel di perangkat.',
  ]);
}

class ValidationFailure extends Failure {
  const ValidationFailure([
    super.message = 'Data yang dimasukkan tidak valid. Periksa kembali form Anda.',
  ]);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([
    super.message = 'Terjadi kesalahan tak terduga. Silakan coba beberapa saat lagi.',
  ]);
}