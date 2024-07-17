import 'package:flutter_dialog/flutter_dialog.dart';
import 'package:intl/intl.dart';

const _maxErrorCount = 10;

class HospitalCheckAppointmentResult {
  final bool canMakeAppointment;
  final String? message;

  HospitalCheckAppointmentResult({
    required this.canMakeAppointment,
    this.message,
  });
}

class HospitalMakeAppointmentResult {
  final bool success;
  final String? message;

  HospitalMakeAppointmentResult({
    required this.success,
    this.message,
  });
}

class HospitalAppointmentSubVuiFlow extends VuiFlow {
  final String department;
  final String date;
  final String time;
  final Future<HospitalMakeAppointmentResult> Function(
    String department,
    String date,
    String time,
  ) onMakingAppointment;

  HospitalAppointmentSubVuiFlow({
    required this.department,
    required this.date,
    required this.time,
    required this.onMakingAppointment,
  });

  @override
  Future<void> handle(
    NluIntent intent, {
    String? utterance,
  }) async {
    final promptForReply =
        "如果一個人發生了需要掛號 $department 的狀況，你會怎麼祝他順利呢？只要一句話就好了。不要 emoji。";
    final greet = await delegate?.onGeneratingResponse(
          promptForReply,
          useDefaultPrompt: false,
        ) ??
        '';
    await delegate?.onPlayingPrompt('好的，正在幫您處理 $department 的掛號，$greet');
    final result = await onMakingAppointment(
      department,
      date,
      time,
    );
    if (result.success) {
      var message = '掛號成功！';
      if (result.message != null) {
        message += result.message!;
      }
      await delegate?.onPlayingPrompt(message);
    } else {
      var message = '很抱歉，現在沒有幫法幫你掛號！';
      if (result.message != null) {
        message += '原因是：${result.message}';
      }
      await delegate?.onPlayingPrompt(message);
    }
    await delegate?.onEndingConversation();
  }
}

class HospitalAppointmentVuiFlow extends VuiFlow {
  Future<HospitalCheckAppointmentResult> Function(
    String department,
    String date,
    String time,
  ) onCheckingIfCanMakeAppointment;

  Future<HospitalMakeAppointmentResult> Function(
    String department,
    String date,
    String time,
  ) onMakingAppointment;

  HospitalAppointmentVuiFlow({
    required this.onCheckingIfCanMakeAppointment,
    required this.onMakingAppointment,
  });

  String? department;
  String? date;
  String? time;
  var errorCount = 0;

  @override
  Future<void> handle(
    NluIntent intent, {
    String? utterance,
  }) async {
    Future<void> handleMaxError() async {
      await delegate?.onSettingCurrentVuiFlow(null);
      await delegate?.onPlayingPrompt('很抱歉，錯誤次數太多');
      await delegate?.onEndingConversation();
    }

    var department = intent.slots['Department'] ?? this.department;
    var date = intent.slots['Date'] ?? this.date;
    var time = intent.slots['Time'] ?? this.time;

    String? errorPrompt = () {
      if (date == null || time == null || department == null) {
        if ((date == null || time == null) && department == null) {
          return '請問您要看哪一科？然後預約哪一天的什麼時間？';
        }
        if (date == null) {
          return '請問您要預約的日期？';
        }
        if (time == null) {
          return '請問您要預約的時間？';
        }
        if (department == null) {
          return '請問您要看哪一科？';
        }
        return '請問您要看哪一科？然後預約哪一天的什麼時間';
      }
      if (time != null) {
        try {
          int.parse(time.split(':')[0]);
        } catch (e) {
          return '很抱歉，請具體說明你要預約的是幾點';
        }
      }
      return null;
    }();

    if (errorPrompt != null) {
      errorCount += 1;
      if (errorCount >= _maxErrorCount) {
        await handleMaxError();
        return;
      }
      await delegate?.onPlayingPrompt(errorPrompt);
      await Future.delayed(const Duration(microseconds: 500));
      final vuiFlow = HospitalAppointmentVuiFlow(
        onMakingAppointment: onMakingAppointment,
        onCheckingIfCanMakeAppointment: onCheckingIfCanMakeAppointment,
      )
        ..date = date
        ..time = time
        ..errorCount = errorCount;
      await delegate?.onSettingCurrentVuiFlow(vuiFlow);
      await delegate?.onStartingAsr();
      return;
    }

    final result = await onCheckingIfCanMakeAppointment(
      department!,
      date!,
      time!,
    );

    if (!result.canMakeAppointment) {
      final message = '很抱歉，無法幫您掛號，原因是：${result.message}';
      await delegate?.onPlayingPrompt(message);
      await delegate?.onEndingConversation();
      return;
    }

    final confirm = ConfirmVuiFlow(
      positiveFlow: HospitalAppointmentSubVuiFlow(
        department: department!,
        date: date!,
        time: time!,
        onMakingAppointment: onMakingAppointment,
      ),
      negativeFlow: CancelledVuiFlow(),
    );

    await delegate?.onPlayingPrompt('好的，請問您確定要掛號嗎？');
    await delegate?.onSettingCurrentVuiFlow(confirm);
    await delegate?.onStartingAsr();
  }

  @override
  String get intent => 'HospitalAppointment';

  @override
  Set<String> get slots => {'Department', 'Date', 'Time'};

  @override
  String? get additionalNluPrompt {
    var message = 'Convert date and time to Gregorian calendar.';
    final now = DateTime.now();
    final today = DateFormat.yMd().format(now);
    message += ' today is $today (Y-M-D)';
    return message;
  }
}
