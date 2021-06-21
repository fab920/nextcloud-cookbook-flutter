import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'keyword.dart';

class RecipeShort extends Equatable {
  final int _recipeId;
  final String _name;
  final String _imageUrl;
  final String _keywords;

  int get recipeId => _recipeId;
  String get name => _name;
  String get keywords => _keywords;
  String get imageUrl => _imageUrl;

  RecipeShort.fromJson(Map<String, dynamic> json)
      : _recipeId = json["recipe_id"] is int
            ? json["recipe_id"]
            : int.parse(json["recipe_id"]),
        _name = json["name"],
        _keywords = json["keywords"],
        _imageUrl = json["imageUrl"] {
    if (_keywords != null &&_keywords.isNotEmpty) {
      List<String> k = _keywords.split("\,");
      k.forEach((element) {
        Keywords().add(element);
      });
    }
  }

  static List<RecipeShort> parseRecipesShort(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    Keywords().clear();

    return parsed
        .map<RecipeShort>((json) => RecipeShort.fromJson(json))
        .toList();
  }

  @override
  List<Object> get props => [_recipeId];
}
