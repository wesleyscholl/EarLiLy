# EarLiLy - iOS Development Setup 🌼

## Prerequisites
- macOS with Xcode 15.0 or later
- iOS 16.0+ deployment target
- Swift 5.0+

## Project Structure
```
EarLiLy/
├── EarLiLy.xcodeproj/         # Xcode project file
├── EarLiLy/
│   ├── EarLiLyApp.swift       # App entry point
│   ├── Models/
│   │   ├── Flashcard.swift    # Flashcard data model
│   │   └── FlashcardStore.swift # Data management & persistence
│   ├── Views/
│   │   ├── ContentView.swift  # Main navigation & home
│   │   ├── FlashcardView.swift # Interactive flashcard with flip animation
│   │   ├── GameView.swift     # Matching game with rewards
│   │   └── ProgressView.swift # Analytics dashboard
│   ├── Helpers/
│   │   └── AnimationHelpers.swift # Reusable animations
│   ├── Assets.xcassets/       # App assets & colors
│   └── Preview Content/       # SwiftUI preview assets
└── README.md
```

## Building the Project

### Option 1: Using Xcode (Recommended)
1. Open `EarLiLy.xcodeproj` in Xcode
2. Select your target device (iPhone or iPad simulator)
3. Press `Cmd + R` to build and run
4. The app will launch in the simulator

### Option 2: Using Command Line
```bash
cd /Users/wscholl/EarLiLy

# Build the project
xcodebuild -project EarLiLy.xcodeproj -scheme EarLiLy -sdk iphonesimulator -configuration Debug build

# Run on simulator (requires simulator to be running)
xcrun simctl install booted build/Debug-iphonesimulator/EarLiLy.app
xcrun simctl launch booted com.earlily.app
```

## Features Implemented ✨

### 1. **Learning Mode**
- Browse flashcards by category (Animals, Food, Colors, Numbers, etc.)
- Swipe-based card navigation with smooth animations
- Tap-to-flip card interaction with 3D rotation
- 8 categories with unique colors and icons

### 2. **Game Mode** 🎮
- Interactive matching game (match words to images)
- Real-time score tracking
- Confetti celebrations on correct matches
- Wiggle animation for incorrect attempts
- Category-based gameplay

### 3. **Progress Tracking** 📊
- Statistics dashboard showing:
  - Total games played
  - Correct answers count
  - Current streak tracking
  - Best streak record
- Category-wise progress breakdown
- Success rate visualization
- Achievement badges system (6 unlockable achievements)

### 4. **Animations** 🎨
- **Bounce**: Spring animations for taps
- **Wiggle**: Shake effect for errors
- **Confetti**: Celebration particles
- **Shimmer**: Highlight effects
- **Pulse**: Breathing animations
- **Flip**: 3D card rotations
- **Gradient backgrounds**: Smooth color transitions

### 5. **Data Persistence**
- Local storage using UserDefaults
- Automatic save/load of flashcards
- Statistics tracking across sessions
- Sample data pre-loaded on first launch

## Customization Guide

### Adding Custom Images
1. Add images to `Assets.xcassets`
2. Update flashcard `imageName` property
3. Replace placeholder icons in `FlashcardView.swift` with actual images:
```swift
Image(flashcard.imageName)
    .resizable()
    .scaledToFit()
```

### Adding New Categories
Edit `Flashcard.swift`:
```swift
enum Category: String, Codable, CaseIterable {
    case yourCategory = "Your Category"
    
    var icon: String {
        case .yourCategory: return "🎯"
    }
    
    var color: Color {
        case .yourCategory: return .indigo
    }
}
```

### Adding More Languages
Edit `FlashcardStore.swift` to add multilingual support:
```swift
Flashcard(
    word: "Cat",
    translations: ["es": "Gato", "fr": "Chat", "de": "Katze"]
)
```

## Architecture Highlights

### MVVM Pattern
- **Models**: `Flashcard`, `FlashcardStore`
- **Views**: SwiftUI views with `@EnvironmentObject`
- **ViewModel**: `FlashcardStore` (ObservableObject)

### State Management
- `@StateObject` for store initialization
- `@EnvironmentObject` for cross-view data sharing
- `@State` for local view state
- `@Binding` for two-way data flow

### Animations
- Spring physics for natural motion
- Gesture-driven interactions
- Particle effects for celebrations
- 3D transformations for card flips

## Design Philosophy for Toddlers 👶

1. **Large Touch Targets**: All interactive elements are sized for small fingers
2. **High Contrast Colors**: Vibrant gradients for visual appeal
3. **Immediate Feedback**: Every interaction has an animation response
4. **Positive Reinforcement**: Confetti and celebrations for success
5. **Simple Navigation**: Tab-based interface with clear icons
6. **No Text-Heavy UI**: Icons and emojis communicate meaning
7. **Forgiving UX**: Easy to recover from mistakes
8. **Engaging Sounds** (add later): Audio feedback enhances experience

## Next Steps 🚀

### Recommended Enhancements:
1. **Add Sound Effects**: Tap, success, and error sounds
2. **Voice Narration**: Speak the word when card is flipped
3. **Camera Integration**: Let parents add custom photos
4. **iCloud Sync**: Share flashcards across devices
5. **Parent Controls**: Settings panel for customization
6. **More Game Modes**: Spelling, listening games
7. **Rewards System**: Stickers and virtual prizes
8. **Accessibility**: VoiceOver support, larger text options

### Assets to Add:
- App icon (1024x1024)
- Custom flashcard images
- Sound effects (.m4a files)
- Launch screen customization

## Testing
Run the app in different simulators:
- iPhone SE (small screen)
- iPhone 15 Pro (standard)
- iPad Pro (tablet layout)

Test gestures:
- Tap cards to flip
- Swipe cards to navigate
- Drag cards in matching game

## Troubleshooting

**Build fails**: 
- Clean build folder: `Cmd + Shift + K`
- Delete DerivedData folder

**Simulator issues**:
- Reset simulator: Device → Erase All Content and Settings

**Performance**:
- Animations may be slower on older devices
- Test on physical device for accurate performance

## Contributing
Feel free to add more categories, animations, or features! The codebase is modular and easy to extend.

## License
MIT License - See LICENSE file

---

**Built with ❤️ for Lily**
