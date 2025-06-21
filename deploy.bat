@echo off
REM CRUD User Docker Deployment Script for Windows

echo.
echo ====================================
echo   CRUD User Docker Deployment
echo ====================================
echo.

echo 🚀 Starting deployment process...

REM Check if Docker is running
echo 📋 Checking Docker status...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not running!
    echo 💡 Please start Docker Desktop first, then try again.
    echo.
    pause
    exit /b 1
)
echo ✅ Docker is running

REM Create .env file if not exists
if not exist .env (
    echo 📝 Creating .env file...
    copy .env.example .env >nul
    echo ✅ .env file created
) else (
    echo ✅ .env file already exists
)

echo.
echo 🔨 Building and starting containers...
echo This may take a few minutes on first run...
echo.

REM Build and start containers
docker-compose down >nul 2>&1
docker-compose up --build -d

if %errorlevel% neq 0 (
    echo ❌ Failed to start containers!
    echo 💡 Check Docker Desktop and try again.
    pause
    exit /b 1
)

echo.
echo ⏳ Waiting for services to be ready...
timeout /t 30 /nobreak >nul

echo.
echo ✅ Deployment completed successfully!
echo.
echo ====================================
echo          Access Information
echo ====================================
echo 🌐 Main Application: http://localhost:8080
echo 🗄️  phpMyAdmin:     http://localhost:8081
echo.
echo ====================================
echo        Database Information  
echo ====================================
echo 🏠 Host:     localhost:3307
echo 🗃️  Database: crud_user
echo 👤 Username: root
echo 🔑 Password: rootpassword
echo.
echo ====================================
echo         Useful Commands
echo ====================================
echo 📊 View logs:    docker-compose logs -f
echo ⏹️  Stop:        docker-compose down
echo 🔄 Restart:     docker-compose restart
echo 🧹 Clean up:    docker-compose down -v
echo.

pause
