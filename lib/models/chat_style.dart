import 'package:flutter/material.dart';

class ChatStyle {
  final Color mainColor;
  final Color visitorColor;
  final TextStyle nameTextStyle;
  final TextStyle messageTextStyle;

  const ChatStyle({
    this.mainColor,
    this.visitorColor,
    this.nameTextStyle,
    this.messageTextStyle,
  });

  ChatStyle copyWith({
    Color mainColor,
    Color visitorColor,
    TextStyle nameTextStyle,
    TextStyle messageTextStyle,
  }) {
    return ChatStyle(
      mainColor: mainColor ?? this.mainColor,
      visitorColor: visitorColor ?? this.visitorColor,
      nameTextStyle: nameTextStyle ?? this.nameTextStyle,
      messageTextStyle: messageTextStyle ?? this.messageTextStyle,
    );
  }
}