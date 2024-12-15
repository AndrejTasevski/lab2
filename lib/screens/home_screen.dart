import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../screens/jokes_by_type_screen.dart';
import '../screens/random_joke_screen.dart';  // Importing RandomJokeScreen

class HomeScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Joke Types"),
        actions: [
          IconButton(
            icon: Icon(Icons.shuffle),  // Shuffle icon for the random joke button
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RandomJokeScreen(), // Navigating to RandomJokeScreen
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: apiService.fetchJokeTypes(), // Fetch joke types from API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final jokeTypes = snapshot.data!;
            return ListView.builder(
              itemCount: jokeTypes.length,
              itemBuilder: (context, index) {
                final type = jokeTypes[index];
                return Card(
                  child: ListTile(
                    title: Text(type),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JokesByTypeScreen(type: type), // Navigate to jokes by type screen
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("No joke types found"));
          }
        },
      ),
    );
  }
}
