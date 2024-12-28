import 'package:flutter/material.dart';

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
  void updateMeal() {
    if (selectedCategory != null && textController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Updated $selectedCategory with "${textController.text}" on $selectedDay for $selectedMealTime.'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please select a category and enter a new item')),
      );
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

            // Submit button to simulate the update
            ElevatedButton(
              onPressed: updateMeal, // Call the updateMeal function
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
