part of 'booking_cubit.dart';

@immutable
class BookingRecord {
  final String department;
  final String date;
  final String time;
  final String username;
  final int number;

  const BookingRecord({
    required this.department,
    required this.date,
    required this.time,
    required this.username,
    required this.number,
  });
}

@immutable
abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingWithData extends BookingState {
  final List<BookingRecord> records;

  BookingWithData(this.records);
}
