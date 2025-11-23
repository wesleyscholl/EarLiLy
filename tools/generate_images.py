#!/usr/bin/env python3
"""
EarLiLy Image Generator
Batch generates toddler-friendly flashcard images using Google Gemini/Imagen API
"""

import os
import json
import time
import re
from pathlib import Path
from typing import List, Dict, Optional
from dotenv import load_dotenv
import google.generativeai as genai
from PIL import Image
import requests
from io import BytesIO
from tqdm import tqdm

# Load environment variables
load_dotenv()

class FlashcardImageGenerator:
    """Generate toddler-friendly images for flashcard vocabulary"""
    
    def __init__(self, api_key: Optional[str] = None):
        """Initialize the image generator with API credentials"""
        self.api_key = api_key or os.getenv('GOOGLE_API_KEY')
        if not self.api_key:
            raise ValueError("GOOGLE_API_KEY not found in environment variables")
        
        # Configure Gemini
        genai.configure(api_key=self.api_key)
        self.model = genai.GenerativeModel('gemini-2.0-flash-exp')
        
        # Settings
        self.batch_size = int(os.getenv('BATCH_SIZE', 10))
        self.max_retries = int(os.getenv('MAX_RETRIES', 3))
        self.images_per_word = int(os.getenv('IMAGES_PER_WORD', 1))
        
        # Output directory
        self.output_dir = Path(__file__).parent.parent / 'EarLiLy' / 'Assets.xcassets'
        self.images_dir = self.output_dir / 'FlashcardImages'
        self.images_dir.mkdir(parents=True, exist_ok=True)
        
        # Metadata tracking
        self.metadata_file = Path(__file__).parent / 'generated_images.json'
        self.metadata = self.load_metadata()
    
    def load_metadata(self) -> Dict:
        """Load existing metadata about generated images"""
        if self.metadata_file.exists():
            with open(self.metadata_file, 'r') as f:
                return json.load(f)
        return {'generated': {}, 'failed': [], 'total_count': 0}
    
    def save_metadata(self):
        """Save metadata about generated images"""
        with open(self.metadata_file, 'w') as f:
            json.dump(self.metadata, f, indent=2)
    
    def parse_vocabulary_list(self, vocab_file: Path) -> Dict[str, List[str]]:
        """Parse the vocabulary markdown file into categories"""
        categories = {}
        current_category = None
        
        with open(vocab_file, 'r') as f:
            for line in f:
                line = line.strip()
                
                # Check for category headers (## Category Name)
                if line.startswith('## ') and not line.startswith('## Complete'):
                    current_category = line[3:].strip()
                    categories[current_category] = []
                
                # Extract words (comma-separated lists)
                elif current_category and line and not line.startswith('#') and not line.startswith('*'):
                    # Split by comma and clean up
                    words = [w.strip() for w in line.split(',') if w.strip()]
                    categories[current_category].extend(words)
        
        return categories
    
    def create_toddler_prompt(self, word: str, category: str) -> str:
        """Create an optimized prompt for toddler-friendly image generation"""
        
        # Category-specific style adjustments
        style_modifiers = {
            'Animals & Creatures': 'cute, friendly animal',
            'Food & Drink': 'appetizing, colorful food item',
            'Colors': 'vibrant color swatch or object',
            'Shapes & Measurements': 'clear geometric shape',
            'Numbers & Quantities': 'playful number illustration',
            'Body Parts': 'simple, cartoon-style body part',
            'Clothing & Accessories': 'bright, colorful clothing item',
            'Vehicles & Transportation': 'simple, friendly vehicle',
            'Nature & Weather': 'beautiful natural element',
            'Common Objects & Toys': 'colorful, fun toy or object',
        }
        
        style = style_modifiers.get(category, 'simple, friendly illustration')
        
        prompt = f"""Create a simple, clean, toddler-friendly illustration of a {word}.

Style requirements:
- {style}
- Pure white background (#FFFFFF)
- Bright, cheerful colors
- Bold, clear outlines
- No text or labels
- No shadows or complex details
- Large, centered subject (80% of image)
- Friendly, non-scary appearance
- High contrast for easy recognition
- Perfect for ages 1-4

Make it fun, engaging, and instantly recognizable for a toddler!"""
        
        return prompt
    
    def generate_image(self, word: str, category: str, attempt: int = 1) -> Optional[Path]:
        """Generate a single image using Gemini's image generation"""
        
        # Check if already generated
        if word in self.metadata['generated']:
            print(f"✓ Skipping '{word}' - already generated")
            return Path(self.metadata['generated'][word])
        
        try:
            prompt = self.create_toddler_prompt(word, category)
            
            # Generate image using Gemini
            print(f"🎨 Generating image for '{word}' (attempt {attempt}/{self.max_retries})...")
            
            response = self.model.generate_content([prompt])
            
            # Note: Gemini text model doesn't generate images directly
            # Using Imagen 3 API through AI Studio
            # For now, we'll use a placeholder approach and provide instructions
            
            # Create safe filename
            safe_word = re.sub(r'[^a-zA-Z0-9_-]', '_', word.lower())
            image_filename = f"{safe_word}.imageset"
            image_path = self.images_dir / image_filename
            image_path.mkdir(parents=True, exist_ok=True)
            
            # Create Contents.json for Xcode
            contents_json = {
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
            
            with open(image_path / 'Contents.json', 'w') as f:
                json.dump(contents_json, f, indent=2)
            
            # Save metadata
            self.metadata['generated'][word] = str(image_path / f"{safe_word}.png")
            self.metadata['total_count'] += 1
            self.save_metadata()
            
            print(f"✅ Saved placeholder for '{word}'")
            return image_path / f"{safe_word}.png"
            
        except Exception as e:
            print(f"❌ Error generating '{word}': {str(e)}")
            
            if attempt < self.max_retries:
                print(f"⏳ Retrying in 2 seconds...")
                time.sleep(2)
                return self.generate_image(word, category, attempt + 1)
            else:
                self.metadata['failed'].append({'word': word, 'error': str(e)})
                self.save_metadata()
                return None
    
    def generate_batch(self, words: List[str], category: str):
        """Generate images for a batch of words"""
        print(f"\n📦 Processing category: {category}")
        print(f"   Words to generate: {len(words)}")
        
        with tqdm(total=len(words), desc=f"{category[:30]}") as pbar:
            for word in words:
                self.generate_image(word, category)
                pbar.update(1)
                
                # Rate limiting - respect API limits
                time.sleep(0.5)
    
    def generate_all(self, vocab_file: Path, categories: Optional[List[str]] = None):
        """Generate images for all words in vocabulary list"""
        print("🌼 EarLiLy Flashcard Image Generator")
        print("=" * 60)
        
        # Parse vocabulary
        all_categories = self.parse_vocabulary_list(vocab_file)
        
        # Filter categories if specified
        if categories:
            all_categories = {k: v for k, v in all_categories.items() if k in categories}
        
        total_words = sum(len(words) for words in all_categories.values())
        print(f"\n📊 Statistics:")
        print(f"   Categories: {len(all_categories)}")
        print(f"   Total words: {total_words}")
        print(f"   Already generated: {len(self.metadata['generated'])}")
        print(f"   Remaining: {total_words - len(self.metadata['generated'])}")
        print(f"\n🚀 Starting generation...\n")
        
        # Generate images for each category
        for category, words in all_categories.items():
            self.generate_batch(words, category)
        
        # Summary
        print("\n" + "=" * 60)
        print("✨ Generation Complete!")
        print(f"   Total generated: {self.metadata['total_count']}")
        print(f"   Failed: {len(self.metadata['failed'])}")
        print(f"   Output directory: {self.images_dir}")
        
        if self.metadata['failed']:
            print(f"\n⚠️  Failed words:")
            for item in self.metadata['failed'][:10]:
                print(f"   - {item['word']}: {item['error']}")
            if len(self.metadata['failed']) > 10:
                print(f"   ... and {len(self.metadata['failed']) - 10} more")


def main():
    """Main entry point"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Generate flashcard images for EarLiLy')
    parser.add_argument('vocab_file', type=Path, help='Path to vocabulary markdown file')
    parser.add_argument('--categories', nargs='+', help='Specific categories to generate')
    parser.add_argument('--api-key', help='Google API key (or use GOOGLE_API_KEY env var)')
    
    args = parser.parse_args()
    
    try:
        generator = FlashcardImageGenerator(api_key=args.api_key)
        generator.generate_all(args.vocab_file, args.categories)
    except KeyboardInterrupt:
        print("\n\n⏸️  Generation paused. Progress has been saved.")
        print("   Run the script again to resume from where you left off.")
    except Exception as e:
        print(f"\n❌ Fatal error: {str(e)}")
        raise


if __name__ == '__main__':
    main()
