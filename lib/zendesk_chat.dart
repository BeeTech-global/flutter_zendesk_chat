library zendesk_chat;

import 'package:flutter/material.dart';
import 'package:zendesk_chat/zendesk_chat_screen.dart';
import 'package:zendesk_flutter_plugin/zendesk_flutter_plugin.dart';

export 'package:zendesk_chat/zendesk_chat_screen.dart';

/// Zendesk Chat Components.
class ZendeskChat {
  final String accountKey;

  final ZendeskFlutterPlugin zendeskFlutterPlugin = ZendeskFlutterPlugin();

  ZendeskChat({@required this.accountKey}) : assert(accountKey != null);

  /// Open zendesk chat screen
  void openChatScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ZendeskChatScreen(),
      ),
    );
  }
}
