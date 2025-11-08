#!/bin/bash
# Render Build Script
# This script runs during the build phase on Render

echo "========================================="
echo "Starting Render Build Process"
echo "========================================="

# Install Python dependencies
echo "📦 Installing Python dependencies..."
pip install -r requirements.txt

echo "========================================="
echo "✅ Build completed successfully!"
echo "========================================="
