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
                  // Day dropdown with white background
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
                      hint: Text('Select Day'),
                      dropdownColor: Colors
                          .white, // Ensure dropdown items also have white background
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
                  // Meal time dropdown with white background
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
                      hint: Text('Select Meal Time'),
                      dropdownColor: Colors
                          .white, // Ensure dropdown items also have white background
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
                  // Category dropdown with white background
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // White background for the dropdown
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
                      hint: Text('Select Category'),
                      dropdownColor: Colors
                          .white, // Ensure dropdown items also have white background
                    ),
                  ),
                  SizedBox(height: 16),

                  // TextField wrapped in a container with white background
                  Container(
                    width: 0.6 *
                        screenWidth, // Container width is 60% of screen width
                    decoration: BoxDecoration(
                      color: Colors
                          .white, // White background for the text field container
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        labelText: 'Enter new item',
                        fillColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      style: TextStyle(color: Colors.black), // Black text color
                    ),
                  ),
                  SizedBox(height: 16),

                  // Submit button to simulate the update
                  ElevatedButton(
                    onPressed: updateMeal,
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      iconColor: Colors.orange, // Button color
                    ),
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
