import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SuccessPage extends StatefulWidget {
  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  String? selectedDay = 'Monday';
  String? selectedMealTime = 'Breakfast';
  String? selectedCategory;
  TextEditingController textController = TextEditingController();

  // List of days of the week
  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  // Meal time options
  List<String> mealTimes = ['Breakfast', 'Lunch', 'Snacks', 'Dinner'];

  // Category options based on meal time
  Map<String, List<String>> categoryOptions = {
    'Breakfast': [
      'Main Dish',
      'Add on',
      'Egg item',
      'Sprout',
      'Bread',
      'Beverages',
      'Milk add-on',
      'Fruits'
    ],
    'Lunch': [
      'Gravy',
      'Dry Vegetable',
      'Dal',
      'Indian Bread',
      'Rice',
      'Curd item',
      'Papad',
      'Salad'
    ],
    'Snacks': ['Main Snack', 'Add ons', 'Bread item', 'Beverages'],
    'Dinner': [
      'Curry',
      'Dry Vegetable',
      'Dal',
      'Indian Bread',
      'Rice',
      'Salad',
      'Sweet Dish'
    ],
  };

  // Function to send the updated meal information to the backend
  Future<void> updateMealInDatabase(
      String day, String mealTime, String category, String newItem) async {
    try {
      final url = Uri.parse(
          'https://mess-app-cmk0.onrender.com'); // Replace with your backend URL

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'day': day,
          'mealTime': mealTime.toLowerCase(), // Send the meal time in lowercase
          'category': category,
          'newItem': newItem,
        }),
      );

      // Check if the response status is OK (200)
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Meal updated successfully')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to update meal')));
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred while updating meal')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Meal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown to select the day of the week
            DropdownButton<String>(
              value: selectedDay,
              onChanged: (String? newValue) {
                setState(() {
                  selectedDay = newValue!;
                });
              },
              items: days.map<DropdownMenuItem<String>>((String day) {
                return DropdownMenuItem<String>(value: day, child: Text(day));
              }).toList(),
            ),

            // Dropdown to select the meal time (Breakfast, Lunch, Snacks, Dinner)
            DropdownButton<String>(
              value: selectedMealTime,
              onChanged: (String? newValue) {
                setState(() {
                  selectedMealTime = newValue!;
                  selectedCategory =
                      null; // Reset category when meal time changes
                });
              },
              items: mealTimes.map<DropdownMenuItem<String>>((String meal) {
                return DropdownMenuItem<String>(value: meal, child: Text(meal));
              }).toList(),
            ),

            // Dropdown to select the category (e.g., "Main Dish", "Gravy", etc.)
            DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              items: selectedMealTime != null
                  ? categoryOptions[selectedMealTime]!
                      .map<DropdownMenuItem<String>>((String category) {
                      return DropdownMenuItem<String>(
                          value: category, child: Text(category));
                    }).toList()
                  : [],
            ),

            // TextField to input the new item name
            TextField(
              controller: textController,
              decoration: InputDecoration(labelText: 'Enter new item'),
            ),

            // Submit button to trigger the update in the database
            ElevatedButton(
              onPressed: () {
                if (selectedCategory != null &&
                    textController.text.isNotEmpty) {
                  updateMealInDatabase(
                    selectedDay!,
                    selectedMealTime!,
                    selectedCategory!,
                    textController.text,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Please select a category and enter a new item')));
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
