import 'package:dialog_app/bloc/booking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(builder: (context, state) {
      if (state is BookingWithData) {
        if (state.records.isEmpty) {
          return const Center(
            child: Text('No bookings yet'),
          );
        }
        return ListView.builder(
          itemCount: state.records.length,
          itemBuilder: (context, index) {
            final record = state.records[index];
            return ListTile(
              title: Text(record.department),
              subtitle: Text('${record.date} ${record.time}'),
              trailing: Text('第 ${record.number} 號'),
            );
          },
        );
      } else {
        return const Center(
          child: Text('No bookings yet'),
        );
      }
    });
  }
}
