import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class RecipesShortProvider {
  Client client = Client();

  Future<List<RecipeShort>> fetchRecipesShort() async {
    AppAuthentication appAuthentication =
        UserRepository().getCurrentAppAuthentication();

    final response = await client.get(
      "${appAuthentication.server}/index.php/apps/cookbook/api/recipes",
      headers: {
        "authorization": appAuthentication.basicAuth,
      },
    );

    if (response.statusCode == 200) {
      return RecipeShort.parseRecipesShort(response.body);
    } else {
      throw Exception(translate('recipe_list.errors.load_failed'));
    }
  }
}
