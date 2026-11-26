import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;
import 'package:msaref/features/main/bloc/main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainState());

  void changePage(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
