import 'package:url_launcher/url_launcher.dart';

class TeamsHelper {
  /// See https://learn.microsoft.com/en-us/microsoftteams/platform/concepts/build-and-test/deep-link-teams#deep-link-to-start-a-new-chatœ
  static sendMessage({
    required String user,
    required String topicName,
    required String message,
  }) {
    final encodedUser = Uri.encodeComponent(user);
    final encodedTopicName = Uri.encodeComponent(topicName);
    final encodedMessage = Uri.encodeComponent(message);

    final url = Uri.parse("https://teams.microsoft.com/l/chat/0/0?"
        "users=$encodedUser&"
        "topicName=$encodedTopicName&"
        "message=$encodedMessage");
    launchUrl(url,
        // mode: LaunchMode.externalApplication
    );
  }
}
