#!/usr/bin/env python3
"""
Quick test script - generates images for a few sample words
Use this to verify your API key and settings before full batch generation
"""

import os
from pathlib import Path
from dotenv import load_dotenv

# Try importing the generator
try:
    from generate_images_imagen import ImagenFlashcardGenerator
except ImportError:
    print("❌ Cannot import generator. Make sure you're in the tools directory.")
    exit(1)

load_dotenv()

def test_generation():
    """Test image generation with a few sample words"""
    
    print("🧪 EarLiLy Image Generation Test")
    print("=" * 60)
    print("")
    
    # Check API key
    api_key = os.getenv('GOOGLE_API_KEY')
    if not api_key or api_key == 'your_api_key_here':
        print("❌ Error: GOOGLE_API_KEY not configured")
        print("")
        print("Please edit the .env file and add your API key:")
        print("  1. Get key from: https://aistudio.google.com/app/apikey")
        print("  2. Edit .env file: nano .env")
        print("  3. Replace 'your_api_key_here' with your actual key")
        print("")
        return False
    
    print(f"✅ API Key configured (ends with ...{api_key[-8:]})")
    print("")
    
    # Test words
    test_words = [
        ("cat", "Animals & Creatures"),
        ("apple", "Food & Drink"),
        ("red", "Colors"),
    ]
    
    print(f"📝 Testing with {len(test_words)} sample words:")
    for word, category in test_words:
        print(f"   - {word} ({category})")
    print("")
    
    try:
        # Create generator
        generator = ImagenFlashcardGenerator(api_key=api_key)
        
        print("🎨 Generating test images...\n")
        
        # Generate each test word
        success_count = 0
        for word, category in test_words:
            print(f"Generating: {word}")
            if generator.generate_image(word, category):
                success_count += 1
                print(f"   ✅ Success!\n")
            else:
                print(f"   ❌ Failed\n")
        
        print("=" * 60)
        print(f"✨ Test Results: {success_count}/{len(test_words)} successful")
        print("")
        
        if success_count > 0:
            print("📁 Check generated images:")
            print(f"   {generator.output_dir}")
            print("")
            print("✅ Setup is working! Ready for full batch generation:")
            print("   python3 generate_images_imagen.py earlily_vocab_list.md")
        else:
            print("❌ No images generated. Please check:")
            print("   - API key is valid")
            print("   - You have Imagen 3 access")
            print("   - API quotas are available")
        
        print("")
        return success_count > 0
        
    except Exception as e:
        print(f"❌ Error during test: {str(e)}")
        print("")
        import traceback
        traceback.print_exc()
        return False

if __name__ == '__main__':
    success = test_generation()
    exit(0 if success else 1)
