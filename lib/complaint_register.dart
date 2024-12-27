import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ComplaintRegister extends StatefulWidget {
  const ComplaintRegister({super.key});

  @override
  _ComplaintRegisterState createState() => _ComplaintRegisterState();
}

class _ComplaintRegisterState extends State<ComplaintRegister> {
  // Controllers for the text fields
  final TextEditingController rollNoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController complaintController = TextEditingController();

  bool isSubmitting = false;

  void _submitForm(
      BuildContext context,
      TextEditingController rollNoController,
      TextEditingController emailController,
      TextEditingController complaintController) async {
    const String scriptURL =
        'https://script.google.com/macros/s/AKfycbxIg_YckWRhWcE0fVtOOf12B9uZEGrhs3K3Npdw1I3D2kWPWVExoK-LOew7fRrAWKHaWA/exec';
    String tempRollNo = rollNoController.text;
    String tempEmail = emailController.text;
    String tempComplaint = complaintController.text;

    if (tempRollNo.isEmpty || tempEmail.isEmpty || tempComplaint.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    String queryString =
        "?email_id=$tempEmail&roll_number=$tempRollNo&complaint=$tempComplaint";

    var finalURI = Uri.parse(scriptURL + queryString);
    var response = await http.get(finalURI);

    setState(() {
      isSubmitting = false;
    });

    if (response.statusCode == 200) {
      var bodyR = convert.jsonDecode(response.body);
      print(bodyR);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Complaint submitted successfully!')),
      );

      // Clear the form after submission
      rollNoController.clear();
      emailController.clear();
      complaintController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit complaint!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double horizontalPadding =
        screenWidth * 0.1; // 10% of screen width for horizontal padding
    double verticalPadding =
        screenHeight * 0.1; // 10% of screen height for vertical padding

    return Scaffold(
      appBar: AppBar(
        title: Text("Complaint Register"),
      ),
      body: Container(
        color: Colors.blue[50], // Light blue background color for contrast
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: verticalPadding),
            child: SingleChildScrollView(
              child: Container(
                width: screenWidth * 0.9, // 90% of the screen width
                decoration: BoxDecoration(
                  color: Colors.white, // White background for the container
                  borderRadius: BorderRadius.circular(
                      10), // Rounded corners for the container
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                      16.0), // Padding inside the container
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Roll No input field
                      TextField(
                        controller: rollNoController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Roll No",
                          hintText: "Enter your Roll Number",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20), // Space between fields

                      // Email input field
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email ID",
                          hintText: "Enter your Email",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20), // Space between fields

                      // Complaint input field
                      TextField(
                        controller: complaintController,
                        keyboardType: TextInputType.text,
                        maxLines: 5, // Allow multi-line input for complaints
                        decoration: InputDecoration(
                          labelText: "Complaint",
                          hintText: "Describe your complaint",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20), // Space for submit button

                      // Submit Button
                      if (isSubmitting)
                        Center(child: CircularProgressIndicator())
                      else
                        ElevatedButton(
                          onPressed: () => _submitForm(
                            context,
                            rollNoController,
                            emailController,
                            complaintController,
                          ),
                          child: Text("Submit"),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
