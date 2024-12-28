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

  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  List<String> mealTimes = ['Breakfast', 'Lunch', 'Snacks', 'Dinner'];

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

  // Simulating the update action (no backend)
  Future<void> updateMeal() async {
    if (selectedCategory != null && textController.text.isNotEmpty) {
      try {
        final response = await http.put(
          Uri.parse('https://your-server-url.com/updateMeal'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'day': selectedDay,
            'mealTime': selectedMealTime,
            'category': selectedCategory,
            'newItem': textController.text,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Meal updated successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update meal!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please select a category and enter a new item')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('Update Meal')),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: 0.8 * screenWidth, // Width set to 80% of screen width
              decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 201, 229, 252), // Blue container
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Heading and dropdown for day selection
                  Text(
                    'Select Day',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // White background for the dropdown
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedDay,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDay = newValue!;
                        });
                      },
                      items: days.map<DropdownMenuItem<String>>((String day) {
                        return DropdownMenuItem<String>(
                            value: day, child: Text(day));
                      }).toList(),
                      isExpanded: true,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Heading and dropdown for meal time selection
                  Text(
                    'Select Time',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // White background for the dropdown
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedMealTime,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMealTime = newValue!;
                          selectedCategory =
                              null; // Reset category when meal time changes
                        });
                      },
                      items: mealTimes
                          .map<DropdownMenuItem<String>>((String meal) {
                        return DropdownMenuItem<String>(
                            value: meal, child: Text(meal));
                      }).toList(),
                      isExpanded: true,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Heading and dropdown for category selection
                  Text(
                    'Select Item',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
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
                      isExpanded: true,
                    ),
                  ),
                  SizedBox(height: 16),

                  // TextField for new item
                  Container(
                    width: 0.6 * screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        labelText: 'Enter new item',
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: updateMeal,
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
