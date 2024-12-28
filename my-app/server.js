// Import necessary modules
require('dotenv').config(); // Load environment variables from .env file

const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const app = express();

// Get the port from environment variables (for Render deployment)
const port = process.env.PORT || 3000; // Default to port 3000 if no Render port is specified

// Enable CORS for cross-origin requests (you can restrict it to specific domains)
app.use(cors()); // CORS middleware

// Enable JSON parsing for incoming requests
app.use(express.json());

// MongoDB URI (should be stored in a .env file for security reasons)
const mongoURI = process.env.MONGODB_URI || 'mongodb+srv://messsecy:messsecy@messiitgoa.axb7c.mongodb.net/mess_iitgoa?retryWrites=true&w=majority&appName=messiitgoa'; 

// Connect to MongoDB
mongoose.connect(mongoURI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => {
    console.log('Connected to MongoDB');
  })
  .catch((err) => {
    console.error('Error connecting to MongoDB:', err);
  });

// Define a Mongoose schema for the menu
const menuSchema = new mongoose.Schema({
  day: String, // Day of the week (e.g., "Monday")
  breakfast: [String], // List of breakfast items
  lunch: [String], // List of lunch items
  snacks: [String], // List of snack items
  dinner: [String], // List of dinner items
});

// Create a model from the menu schema
const Menu = mongoose.model('Menu', menuSchema, 'menu'); // 'menu' is the name of the collection in MongoDB

// Basic route for testing the server
app.get('/', (req, res) => {
  res.send('Welcome to the Mess Menu API');
});

// API endpoint to fetch the menu for a specific day
app.get('/getMenuForDay/:day', async (req, res) => {
  try {
    const { day } = req.params; // Get the 'day' parameter from the URL
    const menuData = await Menu.findOne({ day: day }); // Query the database for the menu of the given day

    if (!menuData) {
      return res.status(404).send('Menu not found for this day');
    }

    res.json(menuData); // Return the menu data as JSON
  } catch (err) {
    console.error('Error fetching menu:', err);
    res.status(500).send('Server error');
  }
});

// Start the server and listen on the specified port
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
