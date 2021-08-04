import 'package:bloc/bloc.dart';

class DemoCubit extends Cubit<String> {
  DemoCubit() : super('');

  void setState(String value) {
    emit(value);
  }
}
