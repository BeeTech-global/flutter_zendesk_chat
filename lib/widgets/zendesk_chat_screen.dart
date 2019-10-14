import 'package:flutter/material.dart';
import 'package:zendesk_chat/models/chat_settings_model.dart';
import 'package:zendesk_chat/widgets/zendesk_chat_widget.dart';
import 'package:zendesk_flutter_plugin/zendesk_flutter_plugin.dart';

class AppBarSettings {
  final String title;
  final TextStyle textStyle;
  final Color backgroundColor;

  AppBarSettings({
    this.title,
    this.textStyle,
    this.backgroundColor,
  });
}

class ZendeskChatScreen extends StatefulWidget {
  final AppBarSettings appBarSettings;
  final ChatSettings chatSettings;
  final ZendeskFlutterPlugin zendeskSdk;

  const ZendeskChatScreen({
    Key key,
    this.appBarSettings,
    @required this.chatSettings,
    @required this.zendeskSdk,
  })  : assert(chatSettings != null),
        assert(zendeskSdk != null),
        super(key: key);
  @override
  _ZendeskChatScreenState createState() => _ZendeskChatScreenState();
}

class _ZendeskChatScreenState extends State<ZendeskChatScreen> {
  AppBarSettings get appBarSettings => widget.appBarSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarSettings?.title ?? '',
          style: appBarSettings?.textStyle,
        ),
        backgroundColor: appBarSettings?.backgroundColor,
      ),
      body: ZendeskChatWidget(
        zendeskSdk: widget.zendeskSdk,
        chatSettings: widget.chatSettings,
      ),
    );
  }
}
