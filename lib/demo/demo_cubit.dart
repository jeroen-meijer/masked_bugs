import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class DemoCubit extends Cubit<String> {
  DemoCubit() : super('');

  void setState(String value) {
    emit(value);
  }
}
