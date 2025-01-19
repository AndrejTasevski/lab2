import 'package:flutter/material.dart';

class FavoriteJokesScreen extends StatefulWidget {
  final Set<Map<String, dynamic>> favoriteJokes;
  final Function(Map<String, dynamic>) onFavoriteToggle;

  FavoriteJokesScreen({
    required this.favoriteJokes,
    required this.onFavoriteToggle,
  });

  @override
  _FavoriteJokesScreenState createState() => _FavoriteJokesScreenState();
}

class _FavoriteJokesScreenState extends State<FavoriteJokesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Jokes"),
        backgroundColor: Colors.deepPurple,
      ),
      body: widget.favoriteJokes.isEmpty
          ? Center(
        child: Text(
          "No favorite jokes yet!",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: widget.favoriteJokes.length,
        itemBuilder: (context, index) {
          final joke = widget.favoriteJokes.elementAt(index);
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                joke['setup'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              subtitle: Text(
                joke['punchline'],
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    widget.onFavoriteToggle(joke);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
