# 🎨 EarLiLy Image Generation Guide

## Quick Start

### 1. Get Your Google AI Studio API Key

1. Visit [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Sign in with your Google account (Pro subscription)
3. Click "Get API Key" or "Create API Key"
4. Copy your API key

### 2. Setup Environment

```bash
cd /Users/wscholl/EarLiLy/tools

# Create .env file with your API key
cp .env.example .env
nano .env  # or use your favorite editor

# Add your API key:
GOOGLE_API_KEY=your_actual_api_key_here
```

### 3. Install Dependencies

```bash
# Install Python packages
pip3 install -r requirements.txt
```

### 4. Copy Vocabulary File

```bash
# Copy the vocabulary list to the tools directory
cp ~/Downloads/earlily_vocab_list.md .
```

### 5. Generate Images

**Option A: Using Imagen 3 (Recommended for best quality)**

```bash
# Generate all images (1000+ words)
python3 generate_images_imagen.py earlily_vocab_list.md

# Generate specific categories only (faster for testing)
python3 generate_images_imagen.py earlily_vocab_list.md --categories "Animals & Creatures" "Food & Drink"

# Use custom API key
python3 generate_images_imagen.py earlily_vocab_list.md --api-key YOUR_KEY_HERE
```

**Option B: Using Gemini (Alternative)**

```bash
python3 generate_images.py earlily_vocab_list.md
```

## Features ✨

### Smart Generation
- ✅ Skips already generated images (resume anytime)
- ✅ Automatic retry on failures (3 attempts)
- ✅ Progress tracking with tqdm
- ✅ Metadata logging (JSON)
- ✅ Rate limiting to respect API quotas

### Toddler-Optimized Prompts
- 🎨 Category-specific styling
- 🤍 Pure white backgrounds
- 🌈 Bright, vibrant colors
- 📏 Bold outlines, minimal details
- 👶 Age-appropriate (1-4 years)
- ❤️ Friendly, non-threatening style

### Output Structure

```
EarLiLy/
├── GeneratedImages/              # High-res source images
│   ├── animals_creatures/
│   │   ├── cat.png
│   │   ├── dog.png
│   │   └── ...
│   ├── food_drink/
│   │   ├── apple.png
│   │   └── ...
│   └── ...
│
├── EarLiLy/Assets.xcassets/
│   └── FlashcardImages/          # Xcode-ready imagesets
│       ├── cat.imageset/
│       │   ├── cat.png
│       │   └── Contents.json
│       ├── dog.imageset/
│       │   ├── dog.png
│       │   └── Contents.json
│       └── ...
│
└── tools/
    ├── image_generation_log.json  # Generation metadata
    └── ...
```

## Estimated Costs & Time ⏱️

### For 1000 Images:
- **Time**: ~30-40 minutes (with rate limiting)
- **API Calls**: 1000 requests
- **Costs**: Check [Google AI Pricing](https://ai.google.dev/pricing)
  - Imagen 3: ~$0.04 per image = ~$40 total
  - With Pro subscription: May have higher quotas

### Rate Limiting:
- 1 second delay between requests (default)
- Adjustable in code: `time.sleep(1)`
- Respects API quotas automatically

## Troubleshooting 🔧

### API Key Issues
```bash
# Verify API key is set
echo $GOOGLE_API_KEY

# Or check .env file
cat .env
```

### Quota Exceeded
```
Error: 429 Too Many Requests
```
**Solution**: 
- Increase delay between requests in code
- Wait and resume later (progress is saved)
- Check your [API quota limits](https://console.cloud.google.com/apis/dashboard)

### Image Quality Issues
**Solution**:
- Edit prompts in `create_prompt()` function
- Adjust style parameters
- Regenerate specific words:
```bash
# Delete from metadata to regenerate
python3 -c "import json; d=json.load(open('image_generation_log.json')); del d['generated']['word_to_redo']; json.dump(d, open('image_generation_log.json','w'))"
```

### Resume After Interruption
```bash
# Just run the same command again!
python3 generate_images_imagen.py earlily_vocab_list.md

# Progress is automatically saved and resumed
```

## Advanced Usage 🚀

### Generate Specific Categories
```bash
# Animals only
python3 generate_images_imagen.py earlily_vocab_list.md \
  --categories "Animals & Creatures"

# Multiple categories
python3 generate_images_imagen.py earlily_vocab_list.md \
  --categories "Animals & Creatures" "Food & Drink" "Colors"
```

### Batch Processing Strategy

**Day 1**: Easy categories (fast generation)
```bash
python3 generate_images_imagen.py earlily_vocab_list.md \
  --categories "Colors" "Shapes & Measurements" "Numbers & Quantities"
```

**Day 2**: Main categories
```bash
python3 generate_images_imagen.py earlily_vocab_list.md \
  --categories "Animals & Creatures" "Food & Drink"
```

**Day 3**: Complex categories
```bash
python3 generate_images_imagen.py earlily_vocab_list.md \
  --categories "Actions & Verbs" "Descriptive Words"
```

### Customize Prompts

Edit `generate_images_imagen.py`:

```python
def create_prompt(self, word: str, category: str) -> str:
    # Modify this function to adjust image style
    prompt = f"""Your custom prompt here for {word}"""
    return prompt
```

### Check Progress

```bash
# View generation statistics
python3 -c "
import json
with open('image_generation_log.json') as f:
    data = json.load(f)
    print(f'Generated: {data[\"total_count\"]}')
    print(f'Failed: {len(data[\"failed\"])}')
    print(f'Categories done: {len(data[\"categories_completed\"])}')
"
```

## Integration with EarLiLy App 📱

### Automatic Integration
Images are automatically saved to:
```
EarLiLy/Assets.xcassets/FlashcardImages/
```

### Update Flashcard Model
The images are named to match vocabulary words:
```swift
// In Flashcard.swift, images will be referenced as:
Flashcard(
    word: "Cat",
    imageName: "cat",  // Matches cat.imageset
    category: .animals
)
```

### Use in SwiftUI
```swift
// Automatically works with generated images
Image("cat")  // Loads from cat.imageset
    .resizable()
    .scaledToFit()
```

## Pro Tips 💡

### 1. Test First
Generate a small category first to verify quality:
```bash
python3 generate_images_imagen.py earlily_vocab_list.md \
  --categories "Colors"
```

### 2. Monitor Costs
- Check [Google Cloud Console](https://console.cloud.google.com/billing)
- Set up billing alerts
- Track usage in AI Studio

### 3. Quality Control
- Review generated images in `GeneratedImages/` folder
- Delete poor quality images from metadata to regenerate
- Adjust prompts for better results

### 4. Backup
```bash
# Backup generated images
tar -czf earlily_images_backup.tar.gz GeneratedImages/

# Backup metadata
cp image_generation_log.json image_generation_log.backup.json
```

### 5. Parallel Processing (Advanced)
```bash
# Split into multiple terminals for faster generation
# Terminal 1: Animals
python3 generate_images_imagen.py earlily_vocab_list.md --categories "Animals & Creatures"

# Terminal 2: Food
python3 generate_images_imagen.py earlily_vocab_list.md --categories "Food & Drink"
```

## Next Steps 🎯

1. ✅ Generate images
2. ✅ Review quality
3. ✅ Update Flashcard.sampleData with new image names
4. ✅ Build and test app in Xcode
5. ✅ Add more words as needed

## Support & Resources 📚

- [Google AI Studio](https://aistudio.google.com/)
- [Imagen 3 Documentation](https://ai.google.dev/gemini-api/docs/imagen)
- [API Pricing](https://ai.google.dev/pricing)
- [Image Generation Best Practices](https://ai.google.dev/gemini-api/docs/imagen)

---

**Happy generating! 🌼**
