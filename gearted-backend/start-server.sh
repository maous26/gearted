#!/bin/bash

# Gearted Backend Server Startup Script
# This script prevents port conflicts by checking and cleaning up existing processes

PORT=3000
NODE_ENV=${NODE_ENV:-development}

echo "🚀 Starting Gearted Backend Server..."
echo "📍 Port: $PORT"
echo "🌍 Environment: $NODE_ENV"

# Function to check if port is in use
check_port() {
    lsof -i :$PORT >/dev/null 2>&1
}

# Function to kill process on port
kill_port_process() {
    echo "⚠️  Port $PORT is already in use. Cleaning up..."
    
    # Get the PID of the process using the port
    PID=$(lsof -ti :$PORT)
    
    if [ ! -z "$PID" ]; then
        echo "🔪 Killing process $PID on port $PORT..."
        kill $PID
        
        # Wait a moment for the process to terminate
        sleep 2
        
        # Check if process is still running
        if check_port; then
            echo "⚠️  Process still running. Force killing..."
            kill -9 $PID
            sleep 1
        fi
        
        echo "✅ Port $PORT is now free."
    fi
}

# Check and clean port if necessary
if check_port; then
    kill_port_process
else
    echo "✅ Port $PORT is available."
fi

# Verify MongoDB is running
echo "🔍 Checking MongoDB connection..."
if ! mongosh --quiet --eval "db.adminCommand('ping')" gearted >/dev/null 2>&1; then
    echo "⚠️  MongoDB is not running. Starting MongoDB..."
    brew services start mongodb-community
    echo "⏳ Waiting for MongoDB to start..."
    sleep 3
fi

# Start the server
echo "🏁 Starting server in $NODE_ENV mode..."

if [ "$NODE_ENV" = "production" ]; then
    # Production mode - use built files
    npm run build && npm start
else
    # Development mode - use nodemon with ts-node
    npm run dev
fi
