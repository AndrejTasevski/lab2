import 'package:flutter/material.dart';
import '../services/api_services.dart';

class JokesByTypeScreen extends StatelessWidget {
  final String type;
  final ApiService apiService = ApiService();

  JokesByTypeScreen({required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$type Jokes")),
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
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                final joke = jokes[index];
                return ListTile(
                  title: Text(joke['setup']),
                  subtitle: Text(joke['punchline']),
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
