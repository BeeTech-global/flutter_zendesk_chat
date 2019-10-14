library zendesk_chat;

import 'package:flutter/material.dart';
import 'package:zendesk_chat/models/models.dart';
import 'package:zendesk_flutter_plugin/zendesk_flutter_plugin.dart';

import 'package:zendesk_chat/widgets/widgets.dart';

export 'package:zendesk_chat/widgets/widgets.dart';
export 'package:zendesk_chat/models/models.dart';

/// Zendesk Chat Components.
class ZendeskChat {
  final String accountKey;

  ZendeskFlutterPlugin zendeskFlutterPlugin = ZendeskFlutterPlugin();

  ZendeskChat({
    @required this.accountKey,
  }) : assert(accountKey != null && accountKey != '') {
    zendeskFlutterPlugin.init(accountKey);
  }

  /// Open zendesk chat screen
  void openChatScreen(BuildContext context, ChatSettings chatSettings) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ZendeskChatScreen(
          zendeskSdk: zendeskFlutterPlugin,
          chatSettings: chatSettings,
        ),
      ),
    );
  }
}
