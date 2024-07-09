import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialog/flutter_dialog.dart';

import 'bloc/booking_cubit.dart';
import 'bloc/dialog_cubit.dart';
import 'bookings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BookingCubit>(create: (context) => BookingCubit()),
        BlocProvider<DialogCubit>(
            create: (context) => DialogCubit(oMakingAppointment: (
                  department,
                  date,
                  time,
                  number,
                ) async {
                  final record = BookingRecord(
                    department: department,
                    date: date,
                    time: time,
                    number: number,
                    username: 'John Doe',
                  );
                  final bookingCubit = BlocProvider.of<BookingCubit>(context);
                  bookingCubit.addRecord(record);
                })),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Dialog Example'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: BlocBuilder<DialogCubit, DialogEngineState>(
        builder: (context, state) {
          if (state is DialogEngineIdling) {
            return const BookingsPage();
          }
          if (state is DialogEngineError) {
            final message = state.errorMessage;
            return Center(
              child: Text('Error occurred: $message'),
            );
          }

          if (state is DialogEngineListening) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Listening...',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(state.asrResult,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge),
                ),
              ],
            ));
          }
          if (state is DialogEngineCompleteListening) {
            return Center(
                child: SingleChildScrollView(
                    child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const CircularProgressIndicator(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(state.asrResult,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge),
                ),
              ],
            )));
          }
          if (state is DialogEnginePlayingTts) {
            return Center(
                child: SingleChildScrollView(
                    child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Playing TTS Prompt...',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(state.prompt,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge),
                ),
              ],
            )));
          }
          return Container();
        },
      ),
      floatingActionButton: BlocBuilder<DialogCubit, DialogEngineState>(
        builder: (context, state) {
          if (state is DialogEngineIdling) {
            return FloatingActionButton(
              onPressed: () async {
                final bloc = BlocProvider.of<DialogCubit>(context);
                await bloc.init();
                await bloc.start();
              },
              tooltip: 'Start',
              child: const Icon(Icons.mic),
            );
          }
          return FloatingActionButton(
            onPressed: () async {
              final bloc = BlocProvider.of<DialogCubit>(context);
              await bloc.stop();
            },
            tooltip: 'Stop',
            child: const Icon(Icons.stop),
          );
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
