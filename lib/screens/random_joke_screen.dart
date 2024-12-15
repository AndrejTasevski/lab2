import 'package:flutter/material.dart';
import '../services/api_services.dart';

class RandomJokeScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Random Joke")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: apiService.fetchRandomJoke(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final joke = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(joke['setup'], style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Text(joke['punchline'], style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          } else {
            return Center(child: Text("No joke found"));
          }
        },
      ),
    );
  }
}
