#!/bin/bash

# Quick setup script for EarLiLy image generation

echo "🌼 EarLiLy Image Generation Setup"
echo "=================================="
echo ""

# Check Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not installed"
    echo "   Install from: https://www.python.org/downloads/"
    exit 1
fi

echo "✅ Python $(python3 --version) found"

# Check pip
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 is required but not installed"
    exit 1
fi

echo "✅ pip3 found"
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
pip3 install -r requirements.txt --quiet

if [ $? -eq 0 ]; then
    echo "✅ Dependencies installed"
else
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo ""

# Check for .env file
if [ ! -f ".env" ]; then
    echo "📝 Creating .env file..."
    cp .env.example .env
    echo "⚠️  Please edit .env and add your Google API key"
    echo "   Get your key from: https://aistudio.google.com/app/apikey"
    echo ""
    echo "   Then run: nano .env"
    echo ""
else
    echo "✅ .env file exists"
fi

# Check for vocabulary file
if [ ! -f "earlily_vocab_list.md" ]; then
    echo ""
    echo "📋 Vocabulary file not found"
    echo "   Please copy it to this directory:"
    echo "   cp ~/Downloads/earlily_vocab_list.md ."
    echo ""
else
    echo "✅ Vocabulary file found"
    
    # Count words
    word_count=$(grep -o ',' earlily_vocab_list.md | wc -l)
    echo "   Estimated words: ~$word_count"
fi

echo ""
echo "=================================="
echo "✨ Setup Complete!"
echo ""
echo "Next steps:"
echo "1. Edit .env and add your Google API key"
echo "2. Copy vocabulary file if needed"
echo "3. Run: python3 generate_images_imagen.py earlily_vocab_list.md"
echo ""
echo "For help: python3 generate_images_imagen.py --help"
echo ""
