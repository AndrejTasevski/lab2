import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../screens/jokes_by_type_screen.dart';
import '../screens/random_joke_screen.dart';

class HomeScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Joke Types"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.shuffle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RandomJokeScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: FutureBuilder<List<String>>(
          future: apiService.fetchJokeTypes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final jokeTypes = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: jokeTypes.length,
                itemBuilder: (context, index) {
                  final type = jokeTypes[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      tileColor: Colors.white,
                      title: Text(
                        type,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JokesByTypeScreen(type: type),
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
      ),
    );
  }
}
