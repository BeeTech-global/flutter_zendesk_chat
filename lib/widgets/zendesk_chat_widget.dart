import 'package:flutter/material.dart';
import 'package:zendesk_chat/models/chat_settings_model.dart';
import 'package:zendesk_flutter_plugin/chat_models.dart';
import 'package:zendesk_flutter_plugin/zendesk_flutter_plugin.dart';

class ZendeskChatWidget extends StatefulWidget {
  final ChatSettings chatSettings;
  final ZendeskFlutterPlugin zendeskSdk;

  const ZendeskChatWidget({
    Key key,
    @required this.zendeskSdk,
    @required this.chatSettings,
  })  : assert(chatSettings != null),
        assert(zendeskSdk != null),
        super(key: key);

  @override
  _ZendeskChatWidgetState createState() => _ZendeskChatWidgetState();
}

class _ZendeskChatWidgetState extends State<ZendeskChatWidget> {
  List<ChatItem> chatLog = [];
  ChatSettings get chatSettings => widget.chatSettings;
  ZendeskFlutterPlugin get zendeskSdk => widget.zendeskSdk;

  final msgController = TextEditingController();

  Future<void> closeConnection() async {
    await zendeskSdk.endChat();
  }

  @override
  void initState() {
    super.initState();

    zendeskSdk.startChat(
      chatSettings?.visitor?.name,
      visitorEmail: chatSettings?.visitor?.email,
      visitorPhone: chatSettings?.visitor?.phone,
      department: chatSettings?.department,
      tags: chatSettings?.tags,
    );

    zendeskSdk.onChatItemsChanged.listen((List<ChatItem> chatLog) {
      if (!mounted) return;
      setState(() {
        this.chatLog = chatLog;
      });
    });
  }

  @override
  dispose() async {
    super.dispose();
    await closeConnection();
  }

  Widget mapChatLogToMessage(ChatItem chatItem) {
    MainAxisAlignment alignment = MainAxisAlignment.start;
    Color color = Colors.green;

    if (chatItem.nick.startsWith('visitor')) {
      alignment = MainAxisAlignment.end;
      color = Colors.blueAccent;
    }

    return Row(
      mainAxisAlignment: alignment,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width / 100 * 80,
          child: Wrap(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Text(
                      chatItem.displayName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    chatItem.message,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.8),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: chatLog.map(mapChatLogToMessage).toList(),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: msgController,
                  minLines: 1,
                  maxLines: 5,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.blue,
                ),
                onPressed: () async {
                  await zendeskSdk.sendMessage(msgController.text);
                  msgController.clear();
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
