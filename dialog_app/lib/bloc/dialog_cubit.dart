import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter_dialog/flutter_dialog.dart';

import 'api_key.dart';
import 'vui_flows/hospital_appointment.dart';
import 'vui_flows/leave_application.dart';
import 'teams_helper.dart';

class DialogCubit extends Cubit<DialogEngineState> {
  final DialogEngine dialogEngine = DialogEngine.standard(geminiApiKey);
  final availableDepartments = [
    '內科',
    '外科',
    '心臟科',
    '神經內科',
    '婦產科',
    '小兒科',
  ];

  final Future<void> Function(
    String date,
    String time,
    String department,
    int number,
  ) oMakingAppointment;

  DialogCubit({
    required this.oMakingAppointment,
  }) : super(DialogEngineIdling()) {
    dialogEngine.ttsEngine.setLanguage('zh-TW');
    dialogEngine.asrEngine.setLanguage('zh-TW');
    dialogEngine.stateStream.listen((state) {
      emit(state);
    });
    dialogEngine.registerFlows([
      HospitalAppointmentVuiFlow(
          onCheckingIfCanMakeAppointment: (department, date, time) async {
        // print('department $department');
        // print('date $date');
        // print('time $time');
        if (!availableDepartments.contains(department)) {
          return HospitalCheckAppointmentResult(
            canMakeAppointment: false,
            message: '我們醫院沒有 $department',
          );
        }
        final hour = int.parse(time.split(':')[0]);
        if (hour < 9 || hour > 17) {
          return HospitalCheckAppointmentResult(
            canMakeAppointment: false,
            message: '我們醫院只有早上九點到下午五點有看診',
          );
        }
        if (hour >= 12 && hour < 14) {
          return HospitalCheckAppointmentResult(
            canMakeAppointment: false,
            message: '我們醫院中午不看診',
          );
        }
        return HospitalCheckAppointmentResult(canMakeAppointment: true);
      }, onMakingAppointment: (department, date, time) async {
        // print('department $department');
        // print('date $date');
        // print('time $time');
        var randomNumber = Random().nextInt(20) + 1;
        var message = '你是第 $randomNumber 號';

        oMakingAppointment(date, time, department, randomNumber);

        return HospitalMakeAppointmentResult(
          success: true,
          message: message,
        );
      }),
      LeaveApplicationVuiFlow(
          onMakingLeaveApplication: (reason, date, text) async {
        TeamsHelper.sendMessage(
          user: "zonble@gmail.com",
          topicName: "Leave Application",
          message: text,
        );

        return true;
      })
    ]);
  }

  Future<void> init() async => await dialogEngine.init();

  Future<void> start() async => await dialogEngine.start();

  Future<void> stop() async => await dialogEngine.stop();
}
