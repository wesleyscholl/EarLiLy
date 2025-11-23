#!/usr/bin/env python3
"""
Single Image Test - Quick verification of Imagen 3 API
Generates one test image to verify setup
"""

import os
from dotenv import load_dotenv

# Load environment
load_dotenv()

print("🧪 Single Image Generation Test")
print("=" * 50)

# Check API key
api_key = os.getenv('GEMINI_API_KEY')
if not api_key or api_key == 'your_api_key_here':
    print("\n❌ Error: GEMINI_API_KEY not set")
    print("\n📝 Quick setup:")
    print("1. Get key: https://aistudio.google.com/app/apikey")
    print("2. Run: echo 'GEMINI_API_KEY=your_actual_key' > .env")
    print("3. Run this script again")
    exit(1)

print(f"✅ API Key found (ends with ...{api_key[-8:]})")

# Import after key check
try:
    import google.generativeai as genai
    from PIL import Image
    import requests
    from io import BytesIO
    import json
    from pathlib import Path
except ImportError:
    print("\n❌ Missing dependencies")
    print("Run: pip3 install google-generativeai pillow python-dotenv requests")
    exit(1)

# Configure Gemini
genai.configure(api_key=api_key)

# Test with a simple word
test_word = "cat"
test_category = "Animals"

print(f"\n🎨 Generating test image: '{test_word}'")
print(f"   Category: {test_category}")

# Create prompt
prompt = f"""A simple, clean illustration for toddler flashcard: a cute, friendly {test_word}, adorable and non-threatening.

Style: cute, friendly, educational, children's book illustration
Background: pure white (#FFFFFF)
Colors: bright, vibrant, high contrast
Details: bold outlines, minimal details, no text
Composition: centered, fills 75% of frame
Age: perfect for ages 1-4 years
Quality: high resolution, crisp and clear

The image should be instantly recognizable and engaging for young children."""

print(f"\n📝 Prompt created")
print(f"   Length: {len(prompt)} characters")

# Try to generate using Gemini's imagen capability
print(f"\n⏳ Calling Google AI API...")
print(f"   This may take 5-10 seconds...")

try:
    # Use Imagen 3 via the API
    from google.generativeai import ImageGenerationModel
    
    # Note: This requires Imagen access through Vertex AI
    # For Google AI Studio, we'll use the REST API
    
    import requests
    
    url = "https://generativelanguage.googleapis.com/v1beta/models/imagen-3.0-generate-001:predict"
    
    headers = {
        'Content-Type': 'application/json',
    }
    
    payload = {
        'instances': [{'prompt': prompt}],
        'parameters': {
            'sampleCount': 1,
            'aspectRatio': '1:1',
        }
    }
    
    response = requests.post(
        f"{url}?key={api_key}",
        headers=headers,
        json=payload,
        timeout=30
    )
    
    print(f"   Response status: {response.status_code}")
    
    if response.status_code == 200:
        result = response.json()
        print(f"\n✅ API call successful!")
        
        # Save result for inspection
        output_dir = Path(__file__).parent / 'test_output'
        output_dir.mkdir(exist_ok=True)
        
        with open(output_dir / 'api_response.json', 'w') as f:
            json.dump(result, f, indent=2)
        
        print(f"   Response saved to: test_output/api_response.json")
        print(f"\n🎉 Test completed! Check the response file.")
        
    else:
        print(f"\n❌ API Error: {response.status_code}")
        print(f"   Message: {response.text[:500]}")
        print(f"\n💡 Possible issues:")
        print(f"   - Imagen 3 may not be available in your region")
        print(f"   - API key may need Vertex AI access")
        print(f"   - Try using Gemini 2.0 Flash Exp instead")
        
except Exception as e:
    print(f"\n❌ Error: {str(e)}")
    print(f"\n💡 Trying alternative approach with Gemini 2.0...")
    
    try:
        # Try with Gemini 2.0 Flash Exp (supports image generation)
        model = genai.GenerativeModel('gemini-2.0-flash-exp')
        
        response = model.generate_content([
            "Generate an image: " + prompt,
        ])
        
        print(f"\n✅ Gemini response received!")
        print(f"   Response type: {type(response)}")
        print(f"   Has candidates: {hasattr(response, 'candidates')}")
        
        if hasattr(response, 'text'):
            print(f"   Text response: {response.text[:200]}")
        
        print(f"\n📝 Note: Gemini 2.0 Flash Exp may not support direct image generation")
        print(f"   Recommendation: Use Vertex AI Imagen API or wait for Imagen 3 access")
        
    except Exception as e2:
        print(f"\n❌ Alternative also failed: {str(e2)}")

print("\n" + "=" * 50)
print("Test complete!")
print("\nNext steps:")
print("1. Check if you have Imagen 3 access in your Google Cloud project")
print("2. Consider using Vertex AI API instead of AI Studio API")
print("3. Or use a placeholder approach until image API is available")
