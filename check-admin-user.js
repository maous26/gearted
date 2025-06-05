// check-admin-user.js
require('dotenv').config({ path: './gearted-backend/.env' });
const mongoose = require('mongoose');
const { Schema } = mongoose;

// Define User schema based on your existing schema
const UserSchema = new Schema({
  username: String,
  email: String,
  password: String,
  profileImage: String,
  provider: {
    type: String,
    enum: ['local', 'google', 'facebook', 'instagram'],
    default: 'local'
  },
  isEmailVerified: {
    type: Boolean,
    default: false
  },
  rating: {
    type: Number,
    default: 0
  },
  salesCount: {
    type: Number,
    default: 0
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

async function checkAdminUser() {
  try {
    console.log('Checking for admin user in database...');
    
    // Get DB_URI from .env file
    const dbUri = process.env.DB_URI;
    if (!dbUri) {
      console.error('DB_URI not found in .env file');
      process.exit(1);
    }
    
    console.log(`Connecting to database: ${dbUri.substring(0, dbUri.indexOf('@') > 0 ? dbUri.indexOf('@') : 20)}...`);
    
    // Connect to MongoDB
    await mongoose.connect(dbUri);
    console.log('Connected to database successfully');
    
    // Define User model
    const User = mongoose.model('User', UserSchema);
    
    // Check if admin exists
    const adminEmail = process.env.ADMIN_EMAIL || 'admin@gearted.com';
    console.log(`Checking if user with email ${adminEmail} exists...`);
    
    const adminUser = await User.findOne({ email: adminEmail });
    
    if (adminUser) {
      console.log('\n✅ Admin user found:');
      console.log(`ID: ${adminUser._id}`);
      console.log(`Username: ${adminUser.username}`);
      console.log(`Email: ${adminUser.email}`);
      console.log(`Created At: ${adminUser.createdAt}`);
    } else {
      console.log('\n❌ Admin user not found!');
      console.log('Creating admin user...');
      
      // Create new admin user
      const newAdmin = new User({
        username: 'admin',
        email: adminEmail,
        password: '$2b$12$qe8gK/8sPmKgBEmUJ0Wj.um7VhnONrDQZHs8lvvKCmZoHfKM.ov6C', // This is bcrypt hash for 'admin123'
        provider: 'local',
        isEmailVerified: true
      });
      
      await newAdmin.save();
      console.log('\n✅ Admin user created:');
      console.log(`ID: ${newAdmin._id}`);
      console.log(`Username: ${newAdmin.username}`);
      console.log(`Email: ${newAdmin.email}`);
    }
  } catch (error) {
    console.error(`\n❌ Error: ${error.message}`);
  } finally {
    // Disconnect from database
    await mongoose.disconnect();
    console.log('\nDisconnected from database');
  }
}

checkAdminUser();
