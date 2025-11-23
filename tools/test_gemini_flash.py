#!/usr/bin/env python3
"""
Test Gemini 2.0 Flash Image Generation
Uses the free Gemini 2.0 Flash model with image generation capability
"""

import os
from dotenv import load_dotenv
from pathlib import Path
import json

load_dotenv()

print("🎨 Testing Gemini 2.0 Flash Image Generation")
print("=" * 60)

# Check API key
api_key = os.getenv('GEMINI_API_KEY')
if not api_key or api_key == 'your_api_key_here':
    print("\n❌ Error: GEMINI_API_KEY not set")
    print("Run: echo 'GEMINI_API_KEY=your_actual_key' > .env")
    exit(1)

print(f"✅ API Key configured")

# Install check
try:
    import google.generativeai as genai
    from PIL import Image
    import io
except ImportError:
    print("\n❌ Missing dependencies")
    print("Run: pip3 install google-generativeai pillow python-dotenv")
    exit(1)

# Configure API
genai.configure(api_key=api_key)

# Create output directory
output_dir = Path(__file__).parent / 'test_output'
output_dir.mkdir(exist_ok=True)

print("\n🧪 Test Configuration:")
print(f"   Word: cat")
print(f"   Model: models/gemini-2.0-flash-exp-image-generation")
print(f"   Output: {output_dir}")

# Create the model with image generation capability
model = genai.GenerativeModel('models/gemini-2.0-flash-exp-image-generation')

# Create prompt
prompt = """Generate a simple, cute illustration of a cat for a toddler flashcard.

Requirements:
- Pure white background
- Bright, cheerful colors
- Friendly, cartoon style
- Bold outlines
- No text
- Large, centered subject
- Perfect for ages 1-4

Create a fun, engaging image that a toddler would love!"""

print("\n⏳ Generating image...")
print("   This may take 10-15 seconds...")

try:
    # Generate image using proper API syntax for image generation models
    response = model.generate_content(
        prompt,
        generation_config={
            "temperature": 1.0,
            "top_p": 0.95,
        }
    )
    
    print("\n✅ Response received!")
    
    # Check if response has image
    if hasattr(response, 'candidates') and response.candidates:
        candidate = response.candidates[0]
        
        print(f"   Candidate parts: {len(candidate.content.parts)}")
        
        # Look for image in parts
        for i, part in enumerate(candidate.content.parts):
            if hasattr(part, 'inline_data'):
                print(f"\n🎉 Image found in part {i}!")
                
                # Save the image
                image_data = part.inline_data.data
                
                # Save raw bytes
                output_file = output_dir / 'cat_test.png'
                with open(output_file, 'wb') as f:
                    f.write(image_data)
                
                print(f"   Saved to: {output_file}")
                
                # Try to open and verify
                try:
                    img = Image.open(io.BytesIO(image_data))
                    print(f"   Size: {img.size}")
                    print(f"   Format: {img.format}")
                    print(f"\n✨ Success! Image generated and saved!")
                except Exception as e:
                    print(f"   ⚠️  Could not verify image: {e}")
                
                break
            elif hasattr(part, 'text'):
                print(f"   Part {i} has text: {part.text[:100]}")
        else:
            print("\n❌ No image data found in response")
            print(f"   Response type: {type(response)}")
            if hasattr(response, 'text'):
                print(f"   Text: {response.text[:200]}")
    else:
        print("\n❌ No candidates in response")
        print(f"   Response: {response}")

except Exception as e:
    print(f"\n❌ Error: {str(e)}")
    print(f"   Error type: {type(e).__name__}")
    
    # Try alternative approach
    print(f"\n💡 Trying alternative API call...")
    
    try:
        # Try direct image generation request
        response = model.generate_content(
            prompt,
            generation_config={
                "temperature": 1.0,
                "top_p": 0.95,
            }
        )
        
        print(f"   Response received: {type(response)}")
        
        if hasattr(response, 'text'):
            print(f"   Text response: {response.text[:300]}")
            print(f"\n💡 Note: Gemini 2.0 Flash may generate image descriptions")
            print(f"   instead of actual images through this API endpoint.")
        
    except Exception as e2:
        print(f"   Alternative failed: {str(e2)}")

print("\n" + "=" * 60)
print("Test complete!")
print("\n📝 Next steps:")
print("1. Check if image was saved to test_output/cat_test.png")
print("2. If not, Gemini 2.0 Flash may need Vertex AI for image generation")
print("3. Alternative: Use placeholder images while waiting for API access")
