import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../services/api_services.dart';
import '../screens/jokes_by_type_screen.dart';
import '../screens/favorite_jokes_screen.dart';
import '../screens/random_joke_screen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../services/notificationService.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  final Set<Map<String, dynamic>> favoriteJokes = {};
  late NotificationService notificationService;

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService();
    notificationService.initNotification();
    notificationService.requestPermissions();
  }


  Future<void> sendTestNotification() async {
    final now = DateTime.now();
    final scheduledDate = now.add(const Duration(seconds: 5));

    await notificationService.notificationsPlugin.zonedSchedule(
      1,
      'Test Notification',
      'This is a test notification.',
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Channel',
          channelDescription: 'Channel for testing notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

    // Show a snack bar with a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Test notification scheduled in 5 seconds!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Joke Types"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteJokesScreen(
                    favoriteJokes: favoriteJokes,
                    onFavoriteToggle: (joke) {
                      setState(() {
                        if (favoriteJokes.contains(joke)) {
                          favoriteJokes.remove(joke);
                        } else {
                          favoriteJokes.add(joke);
                        }
                      });
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: sendTestNotification, // Trigger test notification
          ),
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
      body: FutureBuilder<List<String>>(
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
                    title: Text(
                      type,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JokesByTypeScreen(
                            type: type,
                            onFavoriteToggle: (joke) {
                              setState(() {
                                if (favoriteJokes.contains(joke)) {
                                  favoriteJokes.remove(joke);
                                } else {
                                  favoriteJokes.add(joke);
                                }
                              });
                            },
                            favoriteJokes: favoriteJokes,
                          ),
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
