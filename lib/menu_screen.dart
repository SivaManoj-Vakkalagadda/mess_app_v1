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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                // Day buttons bar
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(7, (index) {
                        return ElevatedButton(
                          onPressed: () => _onDaySelected(index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedDayIndex == index
                                ? Colors.blueAccent
                                : Colors.grey,
                          ),
                          child: Text(
                            daysOfTheWeek[index],
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                // Display meal types for today (Breakfast, Lunch, Snacks, Dinner)
                _buildMealTable('breakfast', todaysMenu['meals']['breakfast']),
                _buildMealTable('lunch', todaysMenu['meals']['lunch']),
                _buildMealTable('snacks', todaysMenu['meals']['snacks']),
                _buildMealTable('dinner', todaysMenu['meals']['dinner']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to build the meal table dynamically
  Widget _buildMealTable(String mealType, Map<String, dynamic> mealItems) {
    if (mealItems == null || mealItems.isEmpty) {
      return Center(child: Text('No data available'));
    }

    List<String> categories = mealItems.keys.toList();

    double screenWidth = MediaQuery.of(context).size.width;
    double firstColumnWidth = 0.3 * screenWidth;
    double secondColumnWidth = 0.5 * screenWidth;

    return Container(
      color: Color.fromARGB(255, 230, 240, 255), // Light blue background
      child: Table(
        border: TableBorder.all(
            borderRadius: BorderRadius.circular(12), color: Colors.blue),
        columnWidths: {
          0: FixedColumnWidth(firstColumnWidth),
          1: FixedColumnWidth(secondColumnWidth),
        },
        children: [
          // Add header row for meal type
          TableRow(
            children: [
              TableCell(
                  child: Center(
                      child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Category',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        fontSize: 18)),
              ))),
              TableCell(
                  child: Center(
                      child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Items',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        fontSize: 18)),
              ))),
            ],
          ),
          for (var category in categories) // Loop through the categories
            TableRow(children: [
              TableCell(
                  child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(category,
                              style: TextStyle(fontWeight: FontWeight.bold))))),
              TableCell(
                  child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(mealItems[category] ?? 'No data',
                              style: TextStyle(fontSize: 16.0))))),
            ])
        ],
      ),
    );
  }
}
