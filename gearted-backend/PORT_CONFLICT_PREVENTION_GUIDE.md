# 🛡️ Port Conflict Prevention Guide - Gearted Backend

## 🚨 **Problem Solved**: EADDRINUSE Error Prevention

This document provides comprehensive solutions to prevent the `Error: listen EADDRINUSE: address already in use :::3000` error.

---

## 🎯 **Quick Solutions**

### **Option 1: Use Safe Development Script (RECOMMENDED)**
```bash
cd /Users/moussa/gearted/gearted-backend
npm run dev:safe
```

### **Option 2: Manual Port Cleanup**
```bash
cd /Users/moussa/gearted/gearted-backend
./kill-port.sh        # Kills process on port 3000
./kill-port.sh 8080    # Kills process on specific port
```

### **Option 3: Quick Command Line**
```bash
# Find and kill process on port 3000
lsof -ti :3000 | xargs kill

# Force kill if needed
lsof -ti :3000 | xargs kill -9
```

---

## 🔧 **Available Scripts**

| Script | Command | Description |
|--------|---------|-------------|
| **Safe Start** | `npm run dev:safe` | Auto-cleanup + start server |
| **Standard Dev** | `npm run dev` | Normal development mode |
| **Port Cleanup** | `./kill-port.sh` | Kill process on port 3000 |
| **Custom Port** | `./kill-port.sh 8080` | Kill process on specific port |

---

## 🛠️ **How It Works**

### **1. Automatic Port Cleanup Script**
The `start-server.sh` script automatically:
- ✅ Checks if port 3000 is in use
- ✅ Kills any existing process
- ✅ Verifies MongoDB is running
- ✅ Starts the server safely

### **2. Enhanced Error Handling**
The server now includes:
- ✅ Specific EADDRINUSE error detection
- ✅ Helpful error messages with solutions
- ✅ Graceful shutdown on port conflicts

---

## 📋 **Prevention Checklist**

### **Before Starting Development:**
- [ ] Always use `npm run dev:safe` instead of `npm run dev`
- [ ] Check if MongoDB is running: `brew services list | grep mongodb`
- [ ] Verify no other Node processes: `ps aux | grep node`

### **If Error Still Occurs:**
1. **Stop all Node processes**: `pkill -f node`
2. **Clean port**: `./kill-port.sh`
3. **Restart MongoDB**: `brew services restart mongodb-community`
4. **Start safely**: `npm run dev:safe`

---

## 🚀 **Development Workflow**

### **Recommended Startup Sequence:**
```bash
# 1. Navigate to backend directory
cd /Users/moussa/gearted/gearted-backend

# 2. Ensure MongoDB is running
brew services start mongodb-community

# 3. Start backend safely (auto-cleanup)
npm run dev:safe

# 4. In another terminal, start mobile app
cd /Users/moussa/gearted/gearted-mobile
flutter run
```

---

## 🔍 **Troubleshooting**

### **Common Issues & Solutions:**

| Issue | Solution |
|-------|----------|
| Port 3000 busy | `./kill-port.sh` |
| MongoDB not running | `brew services start mongodb-community` |
| Permission denied | `chmod +x *.sh` |
| Multiple Node processes | `pkill -f node` |

### **Debug Commands:**
```bash
# Check what's using port 3000
lsof -i :3000

# List all Node processes
ps aux | grep node

# Check MongoDB status
brew services list | grep mongodb

# Test backend health
curl http://localhost:3000/api/health
```

---

## 📱 **Mobile App Integration**

### **Verify Backend Connection:**
1. **Backend running**: `curl http://localhost:3000/api/health`
2. **Mobile app config**: Check `.env` file has `API_URL=http://localhost:3000/api`
3. **Test login**: Use mobile app login screen

---

## ⚡ **Performance Tips**

### **Development Mode:**
- Use `npm run dev:safe` for auto-cleanup
- Keep MongoDB service running: `brew services start mongodb-community`
- Monitor logs in terminal for real-time debugging

### **Production Mode:**
- Build first: `npm run build`
- Use production script: `npm start`
- Set `NODE_ENV=production`

---

## 🎉 **Success Verification**

### **Backend Ready Indicators:**
- ✅ `🚀 Serveur démarré sur le port 3000`
- ✅ `✅ Port 3000 is available.`
- ✅ Health check responds: `{"status":"success"}`

### **Full Stack Ready:**
- ✅ Backend: `http://localhost:3000/api/health`
- ✅ Mobile: Flutter app running in simulator
- ✅ Database: MongoDB connected and responsive

---

## 📝 **Quick Reference**

### **Essential Commands:**
```bash
# Start development safely
npm run dev:safe

# Clean port manually
./kill-port.sh

# Check server health
curl http://localhost:3000/api/health

# Kill all Node processes
pkill -f node

# Restart MongoDB
brew services restart mongodb-community
```

---

**🎯 This solution completely prevents the EADDRINUSE error and ensures smooth development workflow!**
