import 'package:flutter/material.dart';
import 'package:zendesk_chat/models/chat_settings_model.dart';
import 'package:zendesk_flutter_plugin/chat_models.dart';
import 'package:zendesk_flutter_plugin/zendesk_flutter_plugin.dart';

class ChatStyle {
  final Color mainColor;
  final Color visitorColor;
  final TextStyle nameTextStyle;
  final TextStyle descriptionTextStyle;

  const ChatStyle({
    this.mainColor,
    this.visitorColor,
    this.nameTextStyle,
    this.descriptionTextStyle,
  });

  ChatStyle copyWith({
    Color mainColor,
    Color visitorColor,
    TextStyle nameTextStyle,
    TextStyle descriptionTextStyle,
  }) {
    return ChatStyle(
      mainColor: mainColor ?? this.mainColor,
      visitorColor: visitorColor ?? this.visitorColor,
      nameTextStyle: nameTextStyle ?? this.nameTextStyle,
      descriptionTextStyle: descriptionTextStyle ?? this.descriptionTextStyle,
    );
  }
}

class _DefaultStyle extends ChatStyle {
  final Color mainColor = Colors.blue;
  final Color visitorColor = Colors.green;
  final TextStyle nameTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  final TextStyle descriptionTextStyle = const TextStyle(
    color: Colors.white,
  );

  const _DefaultStyle({
    Color mainColor,
    Color visitorColor,
    TextStyle nameTextStyle,
    TextStyle descriptionTextStyle,
  });
}

const ChatStyle _defaultStyle = const _DefaultStyle();

class ZendeskChatWidget extends StatefulWidget {
  final ChatSettings chatSettings;
  final ZendeskFlutterPlugin zendeskSdk;
  final ChatStyle chatStyle;

  const ZendeskChatWidget({
    Key key,
    @required this.zendeskSdk,
    @required this.chatSettings,
    this.chatStyle = _defaultStyle,
  })  : assert(chatSettings != null),
        assert(zendeskSdk != null),
        super(key: key);

  @override
  _ZendeskChatWidgetState createState() => _ZendeskChatWidgetState();
}

class _ZendeskChatWidgetState extends State<ZendeskChatWidget> {
  ConnectionStatus _connectionStatus;
  List<ChatItem> _chatLog = [];

  ChatSettings get chatSettings => widget.chatSettings;

  ZendeskFlutterPlugin get zendeskSdk => widget.zendeskSdk;

  ChatStyle get chatStyle => widget.chatStyle;

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

    zendeskSdk.onConnectionStatusChanged
        .listen((ConnectionStatus connectionStatus) {
      if (!mounted) return;
      setState(() {
        _connectionStatus = connectionStatus;
      });
    });

    zendeskSdk.onChatItemsChanged.listen((List<ChatItem> chatLog) {
      if (!mounted) return;
      setState(() {
        _chatLog = chatLog;
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
    Color color = chatStyle.mainColor;

    if (chatItem.nick.startsWith('visitor')) {
      alignment = MainAxisAlignment.end;
      color = chatStyle.visitorColor;
    }

    return Row(
      mainAxisAlignment: alignment,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(vertical: 5),
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
                      chatItem?.displayName,
                      style: chatStyle.nameTextStyle,
                    ),
                  ),
                  Text(
                    chatItem?.message ?? '',
                    style: chatStyle.descriptionTextStyle,
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
    return Stack(
      children: <Widget>[
        _buildChat(),
        (_connectionStatus == ConnectionStatus.CONNECTING)
            ? _buildLoader()
            : Container(),
      ],
    );
  }

  Widget _buildLoader() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white.withOpacity(0.7),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildChat() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              reverse: true,
              child: Column(
                children: _chatLog.map(mapChatLogToMessage).toList(),
              ),
            ),
          ),
          _chatInput(),
        ],
      ),
    );
  }

  Widget _chatInput() => Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          enabled: _connectionStatus == ConnectionStatus.CONNECTED,
          controller: msgController,
          minLines: 1,
          maxLines: 5,
          decoration: InputDecoration(
            filled: true,
            suffixIcon: IconButton(
              icon: Icon(
                Icons.send,
                // color: Colors.blue,
              ),
              onPressed: () async {
                await zendeskSdk.sendMessage(msgController.text);
                msgController.clear();
              },
            ),
          ),
        ),
      );
}
