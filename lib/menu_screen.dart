import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

int getCurrentDayAsInt() {
  return DateTime.now().weekday - 1; // Convert to 0-based index
}

String getFormattedDate() {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  final String formattedDate = formatter.format(DateTime.now());
  return formattedDate;
}

String getCurrentDay() {
  final now = DateTime.now();
  switch (now.weekday) {
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    case 7:
      return 'Sunday';
    default:
      return '';
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedDayIndex =
      getCurrentDayAsInt(); // Automatically set to today's day
  Map<String, dynamic> todaysMenu = {}; // To store the fetched menu data
  final List<String> daysOfTheWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  bool isLoading = true;

  // Function to update selected day and fetch data from the API
  void _onDaySelected(int index) async {
    setState(() {
      selectedDayIndex = index;
      isLoading = true;
    });

    String day = daysOfTheWeek[selectedDayIndex];
    await _fetchMenuForDay(day);
  }

  // Function to fetch menu for the selected day
  Future<void> _fetchMenuForDay(String day) async {
    try {
      final String baseUrl =
          'https://mess-app-cmk0.onrender.com'; // Ensure HTTPS URL
      final response = await http.get(Uri.parse('$baseUrl/getMenuForDay/$day'));

      if (response.statusCode == 200) {
        // Decode the JSON response
        Map<String, dynamic> menuData = json.decode(response.body);

        setState(() {
          todaysMenu = menuData; // Directly set the entire response
          isLoading = false; // Stop the loading animation
        });
      } else {
        throw 'Failed to load menu. Status Code: ${response.statusCode}';
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching menu: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void initState() {
    super.initState();
    // Automatically fetch the menu for the current day when the app starts
    String currentDay = daysOfTheWeek[selectedDayIndex];
    _fetchMenuForDay(currentDay);
  }

  @override
  Widget build(BuildContext context) {
    String currentDate =
        DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double horizontalPadding =
        screenWidth * 0.1; // 10% of screen width for horizontal padding
    double verticalPadding =
        screenHeight * 0.1; // 10% of screen height for top and bottom padding

    // Fallback if no data is fetched yet
    if (todaysMenu.isEmpty) {
      todaysMenu = {
        'meals': {'breakfast': {}, 'lunch': {}, 'snacks': {}, 'dinner': {}}
      };
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu',
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 230, 240, 255),
                  ),
                  child: Center(
                    child: Text(
                      currentDate,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                // Conditional loading state
                if (isLoading)
                  Center(child: CircularProgressIndicator())
                else
                  Column(
                    children: [
                      for (var mealType in [
                        'breakfast',
                        'lunch',
                        'snacks',
                        'dinner'
                      ])
                        MealCard(
                            mealType: mealType,
                            mealData: todaysMenu['meals'][mealType]),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final String mealType;
  final Map<String, dynamic> mealData;

  MealCard({required this.mealType, required this.mealData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mealType.capitalize(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            if (mealData.isNotEmpty)
              for (var entry in mealData.entries)
                Text('${entry.key}: ${entry.value}'),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

extension StringCapitalize on String {
  String capitalize() => this[0].toUpperCase() + this.substring(1);
}
