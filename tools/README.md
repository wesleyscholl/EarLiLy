# 🎨 EarLiLy Image Generation Tools

Automated batch image generation for 1000+ toddler flashcard vocabulary words using Google's Imagen 3 AI.

## 🚀 Quick Start

```bash
cd /Users/wscholl/EarLiLy/tools

# 1. Run setup
./setup.sh

# 2. Add your Google API key to .env
nano .env  # Add your key from https://aistudio.google.com/app/apikey

# 3. Test with sample words
python3 test_generation.py

# 4. Generate all images
python3 generate_images_imagen.py earlily_vocab_list.md
```

## 📁 Files Overview

| File | Purpose |
|------|---------|
| `generate_images_imagen.py` | Main Imagen 3 batch generator (recommended) |
| `generate_images.py` | Alternative Gemini-based generator |
| `test_generation.py` | Quick test script (3 sample words) |
| `setup.sh` | Automated setup script |
| `requirements.txt` | Python dependencies |
| `.env.example` | Environment template |
| `IMAGE_GENERATION_GUIDE.md` | Detailed usage guide |
| `earlily_vocab_list.md` | 1000+ word vocabulary list |

## ✨ Features

### Smart Generation
- ✅ **Resume capability** - Skips already generated images
- ✅ **Automatic retry** - 3 attempts per failed image
- ✅ **Progress tracking** - Real-time progress bars
- ✅ **Metadata logging** - JSON tracking of all generations
- ✅ **Rate limiting** - Respects API quotas

### Toddler-Optimized
- 🎨 **Category-specific prompts** - Different styles per category
- 🤍 **White backgrounds** - Clean, distraction-free
- 🌈 **Vibrant colors** - High contrast for visibility
- 👶 **Age-appropriate** - Perfect for 1-4 year olds
- ❤️ **Friendly style** - Non-threatening, educational

### Production Ready
- 📦 **Xcode integration** - Auto-creates .imageset folders
- 🗂️ **Organized output** - Categorized folder structure
- 💾 **High resolution** - 1024x1024 PNG format
- 🔄 **Batch processing** - Category-by-category generation

## 📊 Usage Examples

### Test Setup
```bash
# Test with 3 words to verify API key
python3 test_generation.py
```

### Generate Specific Categories
```bash
# Just animals and food
python3 generate_images_imagen.py earlily_vocab_list.md \
  --categories "Animals & Creatures" "Food & Drink"

# Colors and shapes (quick test)
python3 generate_images_imagen.py earlily_vocab_list.md \
  --categories "Colors" "Shapes & Measurements"
```

### Generate Everything
```bash
# All 1000+ words (takes ~30-40 minutes)
python3 generate_images_imagen.py earlily_vocab_list.md
```

### Resume After Interruption
```bash
# Just run the same command - it automatically resumes!
python3 generate_images_imagen.py earlily_vocab_list.md
```

## 📈 Statistics

### Vocabulary Coverage
- **Total words**: 1000+
- **Categories**: 30+
- **Age range**: 1-4 years
- **Source**: MacArthur-Bates CDI + My First 1000 Words

### Generation Estimates
- **Time**: ~2 seconds per image
- **Total time**: ~30-40 minutes for all 1000
- **API calls**: 1 per image + retries
- **Cost**: ~$0.04 per image (Imagen 3 pricing)

## 🗂️ Output Structure

```
EarLiLy/
├── GeneratedImages/              # Source images (organized by category)
│   ├── animals_creatures/
│   │   ├── cat.png
│   │   ├── dog.png
│   │   └── ...
│   ├── food_drink/
│   └── ...
│
└── EarLiLy/Assets.xcassets/
    └── FlashcardImages/          # Xcode-ready imagesets
        ├── cat.imageset/
        │   ├── cat.png
        │   └── Contents.json
        └── ...
```

## 🔧 Configuration

### Environment Variables (.env)
```bash
GOOGLE_API_KEY=your_api_key_here  # Required
BATCH_SIZE=10                      # Images per batch
MAX_RETRIES=3                      # Retry attempts
IMAGES_PER_WORD=1                  # Variations per word
IMAGE_SIZE=1024x1024              # Output resolution
```

### API Key Setup
1. Visit [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Get API Key"
4. Copy key to `.env` file

## 🎯 Categories

The vocabulary is organized into:
- Animals & Creatures (100+ words)
- Food & Drink (100+ words)
- Body Parts (40+ words)
- Clothing & Accessories (40+ words)
- Household Items & Furniture (60+ words)
- Places & Buildings (60+ words)
- Vehicles & Transportation (30+ words)
- Nature & Weather (80+ words)
- Actions & Verbs (200+ words)
- Colors (15 words)
- Shapes & Measurements (40+ words)
- Numbers & Quantities (50+ words)
- Common Objects & Toys (60+ words)
- People & Relationships (60+ words)
- And more...

## 💡 Pro Tips

1. **Test first**: Run `test_generation.py` before full batch
2. **Start small**: Generate one category to check quality
3. **Monitor costs**: Track usage in Google Cloud Console
4. **Check quality**: Review images in `GeneratedImages/` folder
5. **Backup**: Save `image_generation_log.json` regularly

## 🐛 Troubleshooting

### "API Key not found"
```bash
# Check .env file exists and has correct format
cat .env

# Should show: GOOGLE_API_KEY=your_actual_key
```

### "429 Too Many Requests"
- Increase `time.sleep(1)` delay in code
- Wait and resume later (progress is saved)
- Check API quota limits

### Poor Image Quality
- Edit prompts in `create_prompt()` function
- Adjust category-specific styles
- Delete from metadata to regenerate specific words

### Script Interrupted
- Progress is automatically saved!
- Just run the same command again
- It will resume from where it stopped

## 📚 Documentation

- **[IMAGE_GENERATION_GUIDE.md](IMAGE_GENERATION_GUIDE.md)** - Detailed usage guide
- **[../SETUP.md](../SETUP.md)** - Main project setup
- **[../README.md](../README.md)** - Project overview

## 🔗 Resources

- [Google AI Studio](https://aistudio.google.com/)
- [Imagen 3 API Docs](https://ai.google.dev/gemini-api/docs/imagen)
- [API Pricing](https://ai.google.dev/pricing)
- [MacArthur-Bates CDI](https://mb-cdi.stanford.edu/)

## 📝 Notes

### Image Naming Convention
- Lowercase, underscores replace spaces
- `cat` → `cat.png` → `cat.imageset`
- `ice cream` → `ice_cream.png` → `ice_cream.imageset`

### Xcode Integration
Images are automatically:
1. Saved to `Assets.xcassets/FlashcardImages/`
2. Organized as `.imageset` folders
3. Include `Contents.json` metadata
4. Ready to use in SwiftUI: `Image("cat")`

### Metadata Tracking
`image_generation_log.json` contains:
- List of generated images
- Failed attempts with errors
- Generation timestamps
- Category completion status

## 🎨 Customization

### Modify Prompts
Edit `generate_images_imagen.py`:
```python
def create_prompt(self, word: str, category: str) -> str:
    # Customize prompt style here
    prompt = f"""Your custom prompt for {word}"""
    return prompt
```

### Add New Categories
1. Add category to vocabulary file
2. Update `style_guides` dict in `create_prompt()`
3. Run generation for that category

## ⚡ Performance

### Single Category (50 words)
- Time: ~2-3 minutes
- API calls: ~50-60 (including retries)
- Cost: ~$2-3

### Full Generation (1000 words)
- Time: ~30-40 minutes
- API calls: ~1000-1100
- Cost: ~$40-50

### Optimization Tips
- Use `--categories` to limit scope
- Increase batch size for faster processing
- Run during off-peak hours for better API response

---

**Ready to generate amazing flashcard images! 🌼**

For questions or issues, check the main [IMAGE_GENERATION_GUIDE.md](IMAGE_GENERATION_GUIDE.md)
