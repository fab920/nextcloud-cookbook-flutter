import 'package:flutter/material.dart';
import '../models/keyword.dart';
import 'package:flutter_translate/flutter_translate.dart';

typedef SearchFilter<T> = List<String> Function(T t);
typedef ResultBuilder<T> = Widget Function(T t);

/// This class helps to implement a search view, using [SearchDelegate].
/// It can show suggestion & unsuccessful-search widgets.
class RecipeSearchPage<RecipeShort> extends SearchDelegate<RecipeShort> {

  /// List of items where the search is going to take place on.
  /// They have [T] on run time.
  final List<RecipeShort> items;

  /// Method that returns the specific parameters intrinsic
  /// to a [T] instance.
  ///
  /// For example, filter a person by its name & age parameters:
  /// filter: (person) => [
  ///   person.name,
  ///   person.age.toString(),
  /// ]
  ///
  /// Al parameters to filter through must be [String] instances.
  final SearchFilter<RecipeShort> filter;

  /// Method that builds a widget for each item that matches
  /// the current query parameter entered by the user.
  ///
  /// If no builder is provided by the user, the package will try
  /// to display a [ListTile] for each child, with a string
  /// representation of itself as the title.
  final ResultBuilder<RecipeShort> builder;

  RecipeSearchPage({
    this.items,
    this.filter,
    this.builder
  }) : super(
    searchFieldLabel: translate('search.title')
  );

  @override
  List<Widget> buildActions(BuildContext context) {
    // Builds a 'clear' button at the end of the [AppBar]
    return [
      AnimatedOpacity(
        opacity: query.isNotEmpty ? 1.0 : 0.0,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOutCubic,
        child: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Creates a default back button as the leading widget.
    // It's aware of targeted platform.
    // Used to close the view.
    return IconButton(
      icon: const BackButtonIcon(),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    String cleanQuery;
    List<RecipeShort> result = [];
    if (query != null) {
      cleanQuery = query.toLowerCase().trim();

      // First we collect all [String] representation of each [item]
      result  = items.where((item) => filter(item)
      // Then, transforms all results to lower case letters
        .map((value) => {
          if (value != null)
            value.toLowerCase().trim()
          else
            value = ""
        })
        // Finally, checks if any coincide with the cleaned query
        .any((value) {
            return value.toString().contains(cleanQuery) == true;
          },
        ),
      ).toList();
    }

    // Builds a list with all filtered items
    // if query and result list are not empty
    return Theme(
      data: Theme.of(context),
      child: cleanQuery.isEmpty
          ? _suggestions()
          : result.isEmpty
          ? Center(
              child: Text(translate('search.nothing_found')),
            )
          : ListView(children: result.map(builder).toList()),
    );
  }


  Widget _suggestions() {
    return Center(
        child: Wrap(
            spacing: 10,
            children: _keywordChips()
        )
    );
  }

  List<Widget> _keywordChips() {
    List<Widget> l = [];
    List<Keyword> keywords =  Keywords().data();
    if (keywords.length > 20) {
      keywords.removeRange(20, keywords.length);
    }
    keywords.forEach((Keyword k) {
      l.add(
          InkWell(
              child: Chip(
                label: Text(k.title + "(" + k.count.toString() + ")"),
              ),
              onTap: () => {
                query = k.title
              }
          )
      );
    });
    return l;
  }
}