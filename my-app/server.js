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

// API endpoint to update the meal item
app.put('/updateMeal', async (req, res) => {
  const { day, mealTime, category, newItem } = req.body;

  try {
    // Find the menu for the given day
    const menuData = await Menu.findOne({ day: day });

    if (!menuData) {
      return res.status(404).send('Menu not found for this day');
    }

    // Update the appropriate category (meal time)
    const categoryIndex = menuData[mealTime].indexOf(category);

    if (categoryIndex === -1) {
      return res.status(404).send(`Category ${category} not found in ${mealTime}`);
    }

    // Replace the item in the selected category
    menuData[mealTime][categoryIndex] = newItem;

    // Save the updated menu
    await menuData.save();

    res.status(200).send('Meal updated successfully');
  } catch (err) {
    console.error('Error updating meal:', err);
    res.status(500).send('Server error');
  }
});

// Start the server and listen on the specified port
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
