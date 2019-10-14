import 'package:flutter/material.dart';
import 'package:zendesk_chat/models/models.dart';

class ChatSettings {
  final Visitor visitor;
  final String department;
  final List<String> tags;

  ChatSettings({
    @required this.visitor,
    this.department,
    this.tags,
  }) : assert(visitor != null);
}
