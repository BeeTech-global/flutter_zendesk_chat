import 'package:flutter/material.dart';

class Visitor {
  final String name;
  final String email;
  final String phone;

  Visitor({
    @required this.name,
    this.email,
    this.phone,
  }) : assert(name != null);
}
