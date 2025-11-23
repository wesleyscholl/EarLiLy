# 🚀 EarLiLy 🌼
A toddler-friendly iOS flashcard app that teaches early words through simple picture association. 📸✨ Built in SwiftUI and designed to grow with my daughter Lily. 🌱

## Brief description 📝
EarLiLy is an engaging, interactive learning tool for toddlers, helping them learn new words through the power of visual association. Designed with simplicity and accessibility in mind, EarLiLy offers a delightful learning experience for young minds with smooth animations and an intuitive interface.

## ✨ Features

### 🎯 Learning Mode
- Browse flashcards organized by 8 categories (Animals, Food, Colors, Numbers, Shapes, Family, Toys, Nature)
- Tap-to-flip cards with smooth 3D rotation animations
- Swipe-based navigation for easy browsing
- Vibrant color-coded categories with emoji icons

### 🎮 Interactive Game Mode
- Memory matching game (match words to images)
- Real-time score and move tracking
- Confetti celebrations on correct matches 🎉
- Wiggle animations for incorrect attempts
- Category-specific gameplay

### 📊 Progress Tracking
- Detailed statistics dashboard
- Track games played, correct answers, and streaks
- Category-wise progress breakdown with success rates
- 6 unlockable achievement badges
- Visual progress bars and charts

### 🎨 Delightful Animations
- **Bounce**: Spring physics for tap feedback
- **Wiggle**: Shake effects for errors
- **Confetti**: Particle celebrations
- **Shimmer**: Highlight effects
- **Pulse**: Breathing animations
- **3D Flips**: Card rotation effects
- **Gradient backgrounds**: Smooth color transitions

### 💾 Data Persistence
- Automatic save/load of all flashcards
- Statistics tracking across sessions
- Sample data pre-loaded for immediate play
- UserDefaults-based local storage

## 🚀 Quick Start

### Prerequisites
- macOS with Xcode 15.0 or later
- iOS 16.0+ deployment target
- Swift 5.0+

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/wesleyscholl/EarLiLy.git
   cd EarLiLy
   ```

2. **Open in Xcode:**
   ```bash
   open EarLiLy.xcodeproj
   ```

3. **Build and Run:**
   - Select an iPhone simulator (iPhone 15 Pro recommended)
   - Press `Cmd + R` to build and run
   - The app will launch with sample flashcards ready to use!

### Alternative: Command Line Build
```bash
./build.sh
```

## 💻 Usage

### For Parents

**Learning Mode:**
1. Tap a category card (e.g., Animals 🐾)
2. Swipe through flashcards
3. Tap cards to flip and reveal the word
4. Drag cards left/right to navigate

**Game Mode:**
1. Select a category to play
2. Match words with images
3. Track your child's score and moves
4. Celebrate with confetti on success!

**Progress Tracking:**
1. View overall statistics
2. Check category-specific progress
3. See unlocked achievements
4. Monitor success rates

### For Developers

**Adding Custom Flashcards:**
```swift
let newCard = Flashcard(
    word: "Elephant",
    imageName: "elephant",
    translations: ["es": "Elefante", "fr": "Éléphant"],
    category: .animals,
    difficulty: .medium
)
store.addFlashcard(newCard)
```

**Creating New Categories:**
```swift
// In Flashcard.swift
enum Category: String, Codable, CaseIterable {
    case vehicles = "Vehicles"
    
    var icon: String {
        case .vehicles: return "🚗"
    }
    
    var color: Color {
        case .vehicles: return .blue
    }
}
```

## 📁 Project Structure
```
EarLiLy/
├── EarLiLy.xcodeproj/         # Xcode project
├── EarLiLy/
│   ├── EarLiLyApp.swift       # App entry point
│   ├── Models/
│   │   ├── Flashcard.swift    # Data model
│   │   └── FlashcardStore.swift # State management
│   ├── Views/
│   │   ├── ContentView.swift  # Main navigation
│   │   ├── FlashcardView.swift # Interactive flashcard
│   │   ├── GameView.swift     # Matching game
│   │   └── ProgressView.swift # Analytics
│   ├── Helpers/
│   │   └── AnimationHelpers.swift # Reusable animations
│   └── Assets.xcassets/       # Images & colors
├── SETUP.md                   # Detailed setup guide
├── build.sh                   # Build script
└── README.md                  # This file
```

## 🎨 Design Philosophy

Built specifically for toddlers with:
- **Large touch targets** for small fingers
- **High contrast colors** for visual appeal
- **Immediate feedback** on every interaction
- **Positive reinforcement** with celebrations
- **Simple navigation** with clear icons
- **Minimal text** - emojis communicate meaning
- **Forgiving UX** - easy error recovery

## 🎨 Image Generation Tools

**NEW!** Automated batch image generation using Google Imagen 3 AI:

```bash
cd tools
./setup.sh                    # Setup environment
python3 test_generation.py    # Test with 3 sample words
python3 generate_images_imagen.py earlily_vocab_list.md  # Generate all 1000+ images
```

Features:
- ✨ **1000+ vocabulary words** from research-validated sources
- 🎨 **Toddler-optimized prompts** - Bright colors, white backgrounds
- 📦 **Automatic Xcode integration** - Ready-to-use imagesets
- 🔄 **Smart resume** - Pick up where you left off
- 📊 **Progress tracking** - Real-time status

See **[tools/README.md](tools/README.md)** for complete guide.

## 🚧 Roadmap

### Upcoming Features
- [ ] Sound effects and voice narration
- [ ] Camera integration for custom photos
- [ ] iCloud sync across devices
- [ ] Parent controls and settings
- [ ] More game modes (spelling, listening)
- [ ] Virtual rewards and sticker system
- [ ] VoiceOver accessibility support
- [ ] Multilingual UI support

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

See [SETUP.md](SETUP.md) for detailed development guidelines.

## 📄 License

EarLiLy is released under the MIT License. See [LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

- Built with ❤️ for Lily
- Inspired by early childhood learning principles
- Powered by SwiftUI and modern iOS frameworks

---

**Made with love for toddlers learning their first words** 🌼👶📚
