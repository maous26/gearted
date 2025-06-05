#!/bin/bash

# Quick port cleanup script for Gearted development
# Usage: ./kill-port.sh [PORT_NUMBER]
# Default port: 3000

PORT=${1:-3000}

echo "🔍 Checking port $PORT..."

# Check if port is in use
if lsof -i :$PORT >/dev/null 2>&1; then
    echo "⚠️  Port $PORT is in use. Getting process info..."
    
    # Show what's running on the port
    echo "📋 Process using port $PORT:"
    lsof -i :$PORT
    
    # Get PID
    PID=$(lsof -ti :$PORT)
    
    if [ ! -z "$PID" ]; then
        echo "🔪 Killing process $PID..."
        kill $PID
        
        # Wait and check if still running
        sleep 2
        if lsof -i :$PORT >/dev/null 2>&1; then
            echo "⚡ Force killing process $PID..."
            kill -9 $PID
        fi
        
        echo "✅ Port $PORT is now free!"
    else
        echo "❌ Could not find PID for port $PORT"
    fi
else
    echo "✅ Port $PORT is already free."
fi
