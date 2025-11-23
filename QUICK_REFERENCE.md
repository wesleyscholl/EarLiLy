# 🌼 EarLiLy - Quick Reference Card

## 📱 Run the iOS App
```bash
open /Users/wscholl/EarLiLy/EarLiLy.xcodeproj
# Press Cmd + R in Xcode
```

## 🎨 Generate Images

### Setup (One Time)
```bash
cd /Users/wscholl/EarLiLy/tools
./setup.sh
nano .env  # Add: GOOGLE_API_KEY=your_key
```

### Test (3 Sample Images)
```bash
python3 test_generation.py
```

### Generate All (1000+ Images)
```bash
python3 generate_images_imagen.py earlily_vocab_list.md
```

### Generate Specific Categories
```bash
python3 generate_images_imagen.py earlily_vocab_list.md \
  --categories "Animals & Creatures" "Food & Drink"
```

## 📂 Key Locations

| What | Where |
|------|-------|
| Xcode Project | `EarLiLy.xcodeproj` |
| Swift Code | `EarLiLy/` folder |
| Image Tools | `tools/` folder |
| Generated Images | `GeneratedImages/` |
| Xcode Assets | `EarLiLy/Assets.xcassets/FlashcardImages/` |
| Documentation | `*.md` files |

## 🔑 Get API Key
1. Visit: https://aistudio.google.com/app/apikey
2. Sign in with Google account
3. Click "Get API Key"
4. Copy to `tools/.env`

## 📊 Statistics

- **App**: 8 Swift files, ~2500 lines
- **Categories**: 8 built-in, 30+ in vocab
- **Vocabulary**: 1000+ words
- **Animations**: 10+ types
- **Estimated Cost**: ~$40 for all images
- **Generation Time**: ~30-40 minutes

## 🎯 Categories

1. Animals & Creatures
2. Food & Drink
3. Colors
4. Numbers & Quantities
5. Shapes & Measurements
6. Body Parts
7. Clothing & Accessories
8. Household Items
9. Nature & Weather
10. Vehicles
11. People & Relationships
12. Actions & Verbs
13. And 18+ more!

## 🚀 Quick Commands

```bash
# Build app
cd /Users/wscholl/EarLiLy
./build.sh

# Setup image tools
cd tools && ./setup.sh

# Test image generation
python3 test_generation.py

# Generate all images
python3 generate_images_imagen.py earlily_vocab_list.md

# Check progress
python3 -c "import json; print(json.load(open('image_generation_log.json'))['total_count'])"
```

## ✨ Features

### Learn Mode
- Browse by category
- Tap to flip cards
- Swipe to navigate
- 8 colorful categories

### Play Mode
- Matching game
- Score tracking
- Confetti celebrations
- Category selection

### Progress Mode
- Statistics dashboard
- Success rates
- Achievement badges
- Category breakdowns

## 🎨 Animations

- Bounce (tap feedback)
- Wiggle (error shake)
- Confetti (celebrations)
- 3D Flip (card reveal)
- Pulse (breathing)
- Shimmer (highlights)

## 📖 Documentation

- `README.md` - Main overview
- `SETUP.md` - Development guide
- `QUICKSTART.md` - Quick start
- `ANIMATIONS.md` - Animation details
- `PROJECT_SUMMARY.md` - Complete summary
- `tools/README.md` - Image generation
- `tools/IMAGE_GENERATION_GUIDE.md` - Detailed guide

## 🐛 Troubleshooting

### App won't build
```bash
# Clean and rebuild
cd /Users/wscholl/EarLiLy
xcodebuild clean -project EarLiLy.xcodeproj
open EarLiLy.xcodeproj
# Cmd + Shift + K, then Cmd + R
```

### API key not working
```bash
# Check .env file
cd tools
cat .env
# Should show: GOOGLE_API_KEY=your_actual_key
```

### Images not generating
```bash
# Run test first
python3 test_generation.py

# Check logs
cat image_generation_log.json
```

## 💡 Pro Tips

1. **Test First**: Run `test_generation.py` before full batch
2. **Start Small**: Generate one category at a time
3. **Resume Anytime**: Script automatically continues
4. **Monitor Costs**: Check Google Cloud Console
5. **Backup Often**: Save `image_generation_log.json`

## 🎯 Next Steps

1. ✅ Build and test iOS app
2. ✅ Get Google API key
3. ✅ Test image generation (3 samples)
4. ✅ Generate images by category
5. ✅ Review image quality
6. ✅ Update app with images
7. ✅ Test on device
8. ✅ Prepare for distribution

## 📞 Resources

- Google AI Studio: https://aistudio.google.com/
- Imagen Docs: https://ai.google.dev/gemini-api/docs/imagen
- API Pricing: https://ai.google.dev/pricing
- Xcode Download: https://developer.apple.com/xcode/

---

**Everything you need in one place! 🌼**
