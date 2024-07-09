import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());

  void reset() {
    emit(BookingInitial());
  }

  void addRecord(BookingRecord record) {
    if (state is BookingWithData) {
      final records = (state as BookingWithData).records;
      records.add(record);
      emit(BookingWithData(records));
    } else {
      emit(BookingWithData([record]));
    }
  }
}
