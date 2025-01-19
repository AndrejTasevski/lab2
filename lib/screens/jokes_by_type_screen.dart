import 'package:flutter/material.dart';
import '../services/api_services.dart';

class JokesByTypeScreen extends StatelessWidget {
  final String type;
  final Function(Map<String, dynamic>) onFavoriteToggle;
  final Set<Map<String, dynamic>> favoriteJokes;

  JokesByTypeScreen({
    required this.type,
    required this.onFavoriteToggle,
    required this.favoriteJokes,
  });

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return Scaffold(
      appBar: AppBar(
        title: Text("$type Jokes"),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: apiService.fetchJokesByType(type),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final jokes = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                final joke = jokes[index];
                final isFavorite = favoriteJokes.contains(joke);
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
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        onFavoriteToggle(joke);
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("No jokes found"));
          }
        },
      ),
    );
  }
}
