import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Keyword {
  final String title;
  int count = 1;

  Keyword(this.title);
}

class Keywords {
  static final Keywords _keywords = Keywords._internal();
  static List<Keyword> _data = [];
  static Map<String, int> _map = new Map();

  factory Keywords() {
    return _keywords;
  }

  Keywords._internal();

  clear() {
    _data.clear();
    _map.clear();
  }

  add(String title) {
    if (_map.containsKey(title)) {
      _data[_map[title]].count++;
    }
    else {
      _data.add(new Keyword(title));
      _map[title] = _data.length - 1;
    }
  }

  List<Keyword> data() {
    _data.sort((a, b) => b.count.compareTo(a.count));
    return _data;
  }
}


