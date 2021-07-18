import 'package:flutter/material.dart';

class NoteSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Note"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
            showSearch(context: context, delegate: DataSearch());
          } )
        ],
      ),
      drawer: Drawer(),
    );
  }
}

class DataSearch extends SearchDelegate<String>{
  final notes = [
    "Insurance ",
    "Doctor's name",
    "Social security",
    "Home address",
    "Date of birth",
    "Doctor's appointment",
    "Next of kin",
    "Alternative contact",
    "Medication schedule",
    "Dinner schedule",
  ];
  final recentNotes = [
    "Dinner schedule",
    "medication schedule",
    "Doctor's appointment",
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    // actions for search bar
    return[
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          } )
    ];
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading actions on the left of the search bar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){}
      );
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // show result based on selection
    return Container(
      height: 100.0,
      width: 100.0,
      child: Card(
        color: Colors.red,
        child: Center(
          child: Text(query),
        ),
      ),
    );
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when user searches for information
    final suggestionList = query.isEmpty
        ? recentNotes
        : notes.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index)=>ListTile(
        onTap: () {
          showResults(context);
        },
      leading: Icon(Icons.location_city),
      title: Text(suggestionList[index]),
    ),
   itemCount: suggestionList.length,
    );
    }
  }

