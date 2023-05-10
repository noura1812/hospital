// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class FieldsModel {
  String name;
  var icon;
  bool selected;
  FieldsModel({required this.name, required this.icon, this.selected = false});
}
