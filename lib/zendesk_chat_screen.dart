import 'package:flutter/material.dart';

class AppBarSettings {
  final String title;
  final TextStyle textStyle;
  final Color backgroundColor;

  AppBarSettings(this.title, this.textStyle, this.backgroundColor);
}

class ZendeskChatScreen extends StatefulWidget {
  final AppBarSettings appBarSettings;

  const ZendeskChatScreen({Key key, this.appBarSettings}) : super(key: key);
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
          appBarSettings.title,
          style: appBarSettings.textStyle,
        ),
        backgroundColor: appBarSettings.backgroundColor,
      ),
    );
  }
}
