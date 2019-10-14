import 'package:flutter/material.dart';
import 'package:zendesk_chat/zendesk_chat.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final title = 'Flutter Zendesk Chat Demo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final zendeskChat = ZendeskChat(
    accountKey: 'MyqHVBcMtviH16mTlMyl0AlpYYsJLS2i',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.title),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          zendeskChat.openChatScreen(
            context,
            ChatSettings(
              visitor: Visitor(name: 'Eliseu'),
            ),
          );
        },
        tooltip: 'Zendesk Chat',
        child: Icon(Icons.chat),
      ),
    );
  }
}
