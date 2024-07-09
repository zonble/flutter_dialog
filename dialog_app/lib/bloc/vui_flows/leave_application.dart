import 'package:flutter_dialog/flutter_dialog.dart';

const _maxErrorCount = 5;

class LeaveApplicationVuiFlow extends VuiFlow {
  Future<bool> Function(
    String reason,
    String date,
    String text,
  ) onMakingLeaveApplication;

  LeaveApplicationVuiFlow({required this.onMakingLeaveApplication});

  String? date;
  String? reason;
  var errorCount = 0;

  @override
  Future<void> handle(NluIntent intent) async {
    Future<void> handleMaxError() async {
      await delegate?.onSettingCurrentVuiFlow(null);
      await delegate?.onPlayingPrompt('很抱歉，錯誤次數太多');
      await delegate?.onEndingConversation();
    }

    var date = intent.slots['Date'] ?? this.date;
    var reason = intent.slots['Reason'] ?? this.reason;
    var errorCount = this.errorCount;
    if (date == null || reason == null) {
      final prompt = () {
        if (date == null && reason == null) {
          return '請問您要請假的日期與事由？';
        }
        if (date == null) {
          return '請問您要請假的日期？';
        }
        if (reason == null) {
          return '請問您要請假的事由？';
        }
        return '';
      }();

      errorCount += 1;
      if (errorCount >= _maxErrorCount) {
        await handleMaxError();
        return;
      }
      await delegate?.onPlayingPrompt(prompt);
      await Future.delayed(const Duration(microseconds: 500));
      final vuiFlow = LeaveApplicationVuiFlow(
          onMakingLeaveApplication: onMakingLeaveApplication)
        ..date = date
        ..reason = reason
        ..errorCount = errorCount;
      await delegate?.onSettingCurrentVuiFlow(vuiFlow);
      await delegate?.onStartingAsr();
      return;
    }

    final promptForApplication =
        '幫我寫一份關於我要請假的短文，語氣嚴謹而且禮貌，大量使用成語，並且引用唐詩，內容大約兩百中文字，不分段'
        '，請假日期是 $date, 事由是 $reason。不要問我其他額外的問題，像是姓名職位等，也不要出現 emoji。';
    final text = await delegate?.onGeneratingResponse(
          promptForApplication,
          useDefaultPrompt: false,
        ) ??
        '';
    final promptForReply =
        "如果一個人發生了 $reason 的狀況，你會怎麼祝他順利呢？只要一句話就好了，不要出現 emoji。";
    final greet = await delegate?.onGeneratingResponse(
          promptForReply,
          useDefaultPrompt: false,
        ) ??
        '';
    await delegate?.onSettingCurrentVuiFlow(null);
    final result = await onMakingLeaveApplication(reason, date, text);
    if (result) {
      await delegate?.onPlayingPrompt('好的，正在幫您請假！$greet');
    } else {
      await delegate?.onPlayingPrompt('很抱歉，無法幫你請假！但我想告訴你，$greet');
    }
    await Future.delayed(const Duration(microseconds: 500));
    await delegate?.onEndingConversation();
  }

  @override
  String get intent => 'LeaveApplication';

  @override
  List<String> get slots => ['Reason', 'Date'];
}
