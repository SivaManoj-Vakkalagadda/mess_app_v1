import 'package:flutter/material.dart';
import 'package:mess_28/admin.dart';
// import 'package:intl/intl.dart';
// import 'package:mess_23/screens/complaint_register.dart';
// import 'package:mess_23/screens/menu_screen.dart';
import 'package:mess_28/complaint_register.dart';
import 'package:mess_28/menu_screen.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mess IIT',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current date and day

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Hey IITian',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Menu'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance_wallet_rounded),
              title: Text('Complaint Register'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ComplaintRegister()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Admin'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminAccessPage()),
                );
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.details),
            //   title: Text('About Us'),
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            // )
          ],
        ),
      ),
      body: SingleChildScrollView(
        // Wrapping everything inside a ScrollView to make it scrollable
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the current date and day

            SizedBox(height: 20),

            // Displaying the Image with responsive sizing
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.8, // Set to 80% of the screen width
                height: MediaQuery.of(context).size.width *
                    0.5, // Set height as 50% of the screen width
                child: Image.asset(
                  'assets/image/messhall.png',
                  fit: BoxFit.cover, // Ensure the image covers the area
                ),
              ),
            ),

            // Text Content
            SizedBox(height: 20),
            Text(
              "Hey IITian! Check out today's mess menu in the Menu bar. If you have any complaints, write them in the Complaint Register. For more info, contact the Mess Council.",
              style: TextStyle(fontSize: 18),
            ),

            // Add a separator line between sections
            SizedBox(height: 20),
            Divider(),

            // Mess Timings Section
            SizedBox(height: 20),
            Container(
              alignment: AlignmentDirectional.center,
              child: Text(
                "Mess Timings",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),

            // Mess Timings Section (Center aligned)
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.7, // Set to 80% of screen width
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  color: const Color.fromARGB(255, 202, 232, 246),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Breakfast: 7:45 AM - 9:00 AM",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Lunch: 12:00 PM - 2:00 PM",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Snacks: 4:30 PM - 5:30 PM",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Dinner: 7:00 PM - 9:00 PM",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),

            // Add a separator line between sections
            SizedBox(height: 20),
            Divider(),

            // Payment Section (Center aligned)
            SizedBox(height: 20),
            Container(
              alignment: AlignmentDirectional.center,
              child: Text(
                "Payment for Unsubscribed Users",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),

            // Payment Section (Center aligned)
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.7, // Set to 80% of screen width
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 202, 232, 246),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Breakfast: ₹40",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Lunch: ₹60",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Snacks: ₹30",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Dinner: ₹70",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
