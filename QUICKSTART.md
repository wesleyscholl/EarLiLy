# 🚀 Quick Start Guide - EarLiLy

## Open the Project

```bash
cd /Users/wscholl/EarLiLy
open EarLiLy.xcodeproj
```

This will launch Xcode with the EarLiLy project.

## Run in Xcode

1. **Select a Simulator**
   - Click the device dropdown in the top toolbar
   - Choose "iPhone 15 Pro" (or any iPhone/iPad simulator)

2. **Build & Run**
   - Press `Cmd + R` or click the ▶️ play button
   - Wait for the build to complete (~30 seconds first time)
   - The simulator will launch automatically

3. **Explore the App**
   - **Learn Tab**: Browse flashcards by category
   - **Play Tab**: Play the matching game
   - **Progress Tab**: View statistics and achievements

## Features to Try

### Learning Mode
- Tap any category card (Animals, Food, Colors, etc.)
- Tap a flashcard to flip and see the word
- Swipe left/right or drag cards to navigate

### Game Mode
- Select a category to start
- Match words with corresponding images
- Earn points and watch confetti celebrations!
- Check your score and moves

### Progress Dashboard
- View total games played
- See your current streak
- Check category-wise progress
- Unlock achievement badges

## Troubleshooting

### Build Errors
```bash
# Clean build folder
Cmd + Shift + K

# Or from terminal:
cd /Users/wscholl/EarLiLy
xcodebuild clean -project EarLiLy.xcodeproj
```

### Simulator Issues
- Go to: **Device → Erase All Content and Settings**
- Restart Xcode
- Try a different simulator device

### Performance
- Animations may be slower in simulator
- For best performance, test on a physical iOS device
- Go to **Debug → Slow Animations** to disable animation slowdown

## Keyboard Shortcuts in Xcode

- `Cmd + R` - Build and Run
- `Cmd + .` - Stop running app
- `Cmd + B` - Build only
- `Cmd + Shift + K` - Clean build folder
- `Cmd + 1-9` - Navigate between panels
- `Cmd + 0` - Toggle left sidebar
- `Cmd + Opt + 0` - Toggle right sidebar

## Testing Different Devices

Try these simulators to see responsive design:
- iPhone SE (small screen)
- iPhone 15 Pro (standard size)
- iPad Pro 12.9" (tablet layout)

## Live Preview in Xcode

1. Open any View file (e.g., `ContentView.swift`)
2. Look for `#Preview` at the bottom
3. Click "Resume" in the preview panel (right side)
4. Interact with the live preview without building!

## Next Steps

- Add custom flashcard images to `Assets.xcassets`
- Create new flashcards using the + button in Learn mode
- Customize categories in `Flashcard.swift`
- Add sound effects for enhanced experience
- Enable iCloud sync for multi-device support

---

**Ready to learn and play! 🌼**
