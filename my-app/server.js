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
const mongoURI = process.env.MONGODB_URI || 'mongodb+srv://mess_secy:mess_iitgoa@messcluster.olmgi.mongodb.net/mess_iit?retryWrites=true&w=majority&appName=messCluster'; 

// Connect to MongoDB
mongoose.connect(mongoURI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => {
    console.log('Connected to MongoDB');
  })
  .catch((err) => {
    console.error('Error connecting to MongoDB:', err);
  });

// Define a Mongoose schema for the menu (updated to include the new structure)
const menuSchema = new mongoose.Schema({
  day: String, // Day of the week (e.g., "Monday")
  meals: {
    breakfast: {
      main_dish: String,
      add_on: [String],
      egg_item: String,
      sprouts: String,
      bread: String,
      beverages: [String],
      milk_addon: String,
      fruits: String
    },
    lunch: {
      gravy: String,
      dry_vegetable: String,
      dal: String,
      indian_bread: String,
      rice: String,
      curd_item: String,
      papad: String,
      salad: String
    },
    snacks: {
      main_snack: String,
      add_ons: [String],
      bread_item: String,
      beverages: [String]
    },
    dinner: {
      curry: String,
      dry_vegetable: String,
      dal: String,
      indian_bread: String,
      rice: String,
      sweet_dish: String
    }
  }
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

    // Return only the day's menu in a structured map (not an array)
    const dayMenu = {
      meals: {
        breakfast: menuData.meals.breakfast,
        lunch: menuData.meals.lunch,
        snacks: menuData.meals.snacks,
        dinner: menuData.meals.dinner
      }
    };

    res.json(dayMenu); // Return the menu data as JSON
  } catch (err) {
    console.error('Error fetching menu:', err);
    res.status(500).send('Server error');
  }
});

// Start the server and listen on the specified port
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
