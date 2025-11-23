#!/usr/bin/env python3
"""
EarLiLy Imagen 3 Batch Generator
Uses Google's Imagen 3 API for high-quality toddler flashcard images
Optimized for Google AI Studio Pro subscription
"""

import os
import json
import time
import re
from pathlib import Path
from typing import List, Dict, Optional
from dotenv import load_dotenv
import requests
from PIL import Image
from io import BytesIO
from tqdm import tqdm
import base64

load_dotenv()

class ImagenFlashcardGenerator:
    """Generate images using Imagen 3 API"""
    
    def __init__(self, api_key: Optional[str] = None):
        self.api_key = api_key or os.getenv('GOOGLE_API_KEY')
        if not self.api_key:
            raise ValueError("GOOGLE_API_KEY not found. Get it from https://aistudio.google.com/app/apikey")
        
        # Imagen 3 API endpoint
        self.api_endpoint = "https://generativelanguage.googleapis.com/v1beta/models/imagen-3.0-generate-001:predict"
        
        # Settings
        self.batch_size = int(os.getenv('BATCH_SIZE', 5))
        self.max_retries = int(os.getenv('MAX_RETRIES', 3))
        
        # Output paths
        self.base_dir = Path(__file__).parent.parent
        self.output_dir = self.base_dir / 'GeneratedImages'
        self.output_dir.mkdir(parents=True, exist_ok=True)
        
        # Assets for Xcode
        self.assets_dir = self.base_dir / 'EarLiLy' / 'Assets.xcassets' / 'FlashcardImages'
        self.assets_dir.mkdir(parents=True, exist_ok=True)
        
        # Metadata
        self.metadata_file = Path(__file__).parent / 'image_generation_log.json'
        self.metadata = self.load_metadata()
        
        print("🎨 Imagen 3 Flashcard Generator Initialized")
        print(f"   API Key: {'✓ Configured' if self.api_key else '✗ Missing'}")
        print(f"   Output: {self.output_dir}")
    
    def load_metadata(self) -> Dict:
        """Load generation history"""
        if self.metadata_file.exists():
            with open(self.metadata_file, 'r') as f:
                return json.load(f)
        return {
            'generated': {},
            'failed': [],
            'total_count': 0,
            'categories_completed': []
        }
    
    def save_metadata(self):
        """Save generation progress"""
        with open(self.metadata_file, 'w') as f:
            json.dump(self.metadata, f, indent=2)
    
    def parse_vocabulary(self, vocab_file: Path) -> Dict[str, List[str]]:
        """Parse vocabulary markdown into categories"""
        categories = {}
        current_category = None
        
        with open(vocab_file, 'r') as f:
            content = f.read()
        
        # Split by ## headers
        sections = re.split(r'\n##\s+', content)
        
        for section in sections[1:]:  # Skip preamble
            lines = section.split('\n')
            category = lines[0].strip()
            
            # Skip metadata sections
            if any(skip in category.lower() for skip in ['complete word list', 'total words', 'note:', 'recommended']):
                continue
            
            # Extract words from the category
            words = []
            for line in lines[1:]:
                line = line.strip()
                if line and not line.startswith('#') and not line.startswith('*'):
                    # Split by comma and clean
                    line_words = [w.strip() for w in line.split(',') if w.strip()]
                    words.extend(line_words)
            
            if words:
                categories[category] = words
        
        return categories
    
    def create_prompt(self, word: str, category: str) -> str:
        """Create toddler-optimized prompt for Imagen 3"""
        
        # Category-specific guidance
        style_guides = {
            'Animals & Creatures': f'a cute, friendly {word}, adorable and non-threatening',
            'Food & Drink': f'a delicious-looking {word}, appetizing and colorful',
            'Body Parts': f'a cartoon {word}, simple and educational',
            'Clothing & Accessories': f'a bright, colorful {word}',
            'Household Items & Furniture': f'a simple, recognizable {word}',
            'Vehicles & Transportation': f'a friendly, colorful {word}',
            'Nature & Weather': f'a beautiful {word}, vibrant and cheerful',
            'Colors': f'a {word} colored object or shape',
            'Shapes & Measurements': f'a clear {word} shape',
            'Numbers & Quantities': f'the number {word} in a playful style',
            'Common Objects & Toys': f'a fun, colorful {word}',
            'People & Relationships': f'a friendly cartoon {word}, diverse and inclusive',
        }
        
        subject = style_guides.get(category, f'a simple, clear {word}')
        
        prompt = f"""A simple, clean illustration for toddler flashcard: {subject}.

Style: cute, friendly, educational, children's book illustration
Background: pure white (#FFFFFF)
Colors: bright, vibrant, high contrast
Details: bold outlines, minimal details, no text
Composition: centered, fills 75% of frame
Age: perfect for ages 1-4 years
Quality: high resolution, crisp and clear

The image should be instantly recognizable and engaging for young children."""
        
        return prompt
    
    def generate_with_imagen(self, prompt: str, word: str) -> Optional[Image.Image]:
        """Call Imagen 3 API to generate image"""
        
        headers = {
            'Content-Type': 'application/json',
        }
        
        payload = {
            'instances': [
                {
                    'prompt': prompt
                }
            ],
            'parameters': {
                'sampleCount': 1,
                'aspectRatio': '1:1',
                'safetyFilterLevel': 'block_only_high',
                'personGeneration': 'allow_adult'
            }
        }
        
        try:
            response = requests.post(
                f"{self.api_endpoint}?key={self.api_key}",
                headers=headers,
                json=payload,
                timeout=60
            )
            
            if response.status_code == 200:
                result = response.json()
                
                # Extract image from response
                if 'predictions' in result and len(result['predictions']) > 0:
                    image_data = result['predictions'][0]
                    
                    # Decode base64 image
                    if 'bytesBase64Encoded' in image_data:
                        img_bytes = base64.b64decode(image_data['bytesBase64Encoded'])
                        img = Image.open(BytesIO(img_bytes))
                        return img
                    elif 'image' in image_data:
                        img_bytes = base64.b64decode(image_data['image'])
                        img = Image.open(BytesIO(img_bytes))
                        return img
            
            print(f"   ⚠️  API Error {response.status_code}: {response.text[:200]}")
            return None
            
        except Exception as e:
            print(f"   ❌ Request failed: {str(e)}")
            return None
    
    def save_image(self, img: Image.Image, word: str, category: str) -> Path:
        """Save image and create Xcode asset"""
        
        # Create safe filename
        safe_word = re.sub(r'[^a-zA-Z0-9_-]', '_', word.lower())
        safe_category = re.sub(r'[^a-zA-Z0-9_-]', '_', category.lower().replace(' ', '_'))
        
        # Save high-res PNG in GeneratedImages
        output_path = self.output_dir / safe_category
        output_path.mkdir(parents=True, exist_ok=True)
        
        img_file = output_path / f"{safe_word}.png"
        img.save(img_file, 'PNG', optimize=True)
        
        # Create Xcode imageset
        imageset_dir = self.assets_dir / f"{safe_word}.imageset"
        imageset_dir.mkdir(parents=True, exist_ok=True)
        
        # Copy image to imageset
        xcode_img = imageset_dir / f"{safe_word}.png"
        img.save(xcode_img, 'PNG', optimize=True)
        
        # Create Contents.json
        contents = {
            "images": [
                {
                    "filename": f"{safe_word}.png",
                    "idiom": "universal",
                    "scale": "1x"
                }
            ],
            "info": {
                "author": "xcode",
                "version": 1
            },
            "properties": {
                "template-rendering-intent": "original"
            }
        }
        
        with open(imageset_dir / 'Contents.json', 'w') as f:
            json.dump(contents, f, indent=2)
        
        return img_file
    
    def generate_image(self, word: str, category: str, attempt: int = 1) -> bool:
        """Generate and save a single flashcard image"""
        
        # Skip if already generated
        if word in self.metadata['generated']:
            return True
        
        try:
            prompt = self.create_prompt(word, category)
            
            print(f"   🎨 '{word}' (attempt {attempt}/{self.max_retries})")
            
            # Generate image
            img = self.generate_with_imagen(prompt, word)
            
            if img:
                # Save image
                img_path = self.save_image(img, word, category)
                
                # Update metadata
                self.metadata['generated'][word] = {
                    'path': str(img_path),
                    'category': category,
                    'timestamp': time.time()
                }
                self.metadata['total_count'] += 1
                self.save_metadata()
                
                print(f"   ✅ Saved: {word}")
                return True
            else:
                # Retry logic
                if attempt < self.max_retries:
                    print(f"   ⏳ Retrying...")
                    time.sleep(2)
                    return self.generate_image(word, category, attempt + 1)
                else:
                    raise Exception("Max retries exceeded")
        
        except Exception as e:
            print(f"   ❌ Failed: {word} - {str(e)}")
            self.metadata['failed'].append({
                'word': word,
                'category': category,
                'error': str(e),
                'timestamp': time.time()
            })
            self.save_metadata()
            return False
    
    def generate_category(self, category: str, words: List[str]):
        """Generate all images for a category"""
        print(f"\n📦 Category: {category}")
        print(f"   Words: {len(words)}")
        
        # Filter out already generated
        remaining = [w for w in words if w not in self.metadata['generated']]
        print(f"   Remaining: {len(remaining)}")
        
        if not remaining:
            print("   ✓ Already complete!")
            return
        
        success_count = 0
        with tqdm(total=len(remaining), desc=category[:40]) as pbar:
            for word in remaining:
                if self.generate_image(word, category):
                    success_count += 1
                pbar.update(1)
                
                # Rate limiting - be nice to the API
                time.sleep(1)
        
        print(f"   ✅ Completed: {success_count}/{len(remaining)}")
        
        if success_count == len(remaining):
            self.metadata['categories_completed'].append(category)
            self.save_metadata()
    
    def generate_all(self, vocab_file: Path, limit_categories: Optional[List[str]] = None):
        """Generate all flashcard images"""
        
        print("\n" + "=" * 70)
        print("🌼 EarLiLy Flashcard Image Generator - Imagen 3")
        print("=" * 70)
        
        # Parse vocabulary
        categories = self.parse_vocabulary(vocab_file)
        
        # Filter if specified
        if limit_categories:
            categories = {k: v for k, v in categories.items() if k in limit_categories}
        
        total_words = sum(len(words) for words in categories.values())
        already_done = len(self.metadata['generated'])
        
        print(f"\n📊 Statistics:")
        print(f"   Categories: {len(categories)}")
        print(f"   Total words: {total_words}")
        print(f"   Already generated: {already_done}")
        print(f"   Remaining: {total_words - already_done}")
        print(f"   Failed previously: {len(self.metadata['failed'])}")
        
        # Estimate cost and time
        remaining = total_words - already_done
        est_minutes = (remaining * 2) / 60  # ~2 seconds per image
        print(f"\n⏱️  Estimated time: {est_minutes:.1f} minutes")
        print(f"💰 API costs: Check your Google AI Studio usage\n")
        
        input("Press Enter to start generation (Ctrl+C to cancel)...")
        
        # Generate each category
        for category, words in categories.items():
            self.generate_category(category, words)
        
        # Final summary
        print("\n" + "=" * 70)
        print("✨ Generation Complete!")
        print("=" * 70)
        print(f"   Total generated: {self.metadata['total_count']}")
        print(f"   Failed: {len(self.metadata['failed'])}")
        print(f"   Categories completed: {len(self.metadata['categories_completed'])}")
        print(f"\n📁 Output locations:")
        print(f"   Images: {self.output_dir}")
        print(f"   Xcode Assets: {self.assets_dir}")
        print(f"   Metadata: {self.metadata_file}")
        
        if self.metadata['failed']:
            print(f"\n⚠️  Failed images ({len(self.metadata['failed'])}):")
            for item in self.metadata['failed'][:5]:
                print(f"   - {item['word']} ({item['category']})")
            if len(self.metadata['failed']) > 5:
                print(f"   ... and {len(self.metadata['failed']) - 5} more")


def main():
    import argparse
    
    parser = argparse.ArgumentParser(
        description='Generate toddler flashcard images using Imagen 3',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Generate all images
  python generate_images_imagen.py /path/to/vocab_list.md
  
  # Generate specific categories only
  python generate_images_imagen.py vocab.md --categories "Animals & Creatures" "Food & Drink"
  
  # Use custom API key
  python generate_images_imagen.py vocab.md --api-key YOUR_KEY_HERE
        """
    )
    
    parser.add_argument('vocab_file', type=Path, help='Vocabulary markdown file')
    parser.add_argument('--categories', nargs='+', help='Specific categories to generate')
    parser.add_argument('--api-key', help='Google API key (or set GOOGLE_API_KEY env var)')
    
    args = parser.parse_args()
    
    if not args.vocab_file.exists():
        print(f"❌ Error: File not found: {args.vocab_file}")
        return
    
    try:
        generator = ImagenFlashcardGenerator(api_key=args.api_key)
        generator.generate_all(args.vocab_file, args.categories)
    
    except KeyboardInterrupt:
        print("\n\n⏸️  Generation paused - progress saved")
        print("   Run again to resume from where you left off")
    
    except Exception as e:
        print(f"\n❌ Error: {str(e)}")
        import traceback
        traceback.print_exc()


if __name__ == '__main__':
    main()
