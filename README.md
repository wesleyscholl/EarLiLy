# 🚀 Earlily 🌼
A toddler-friendly iOS flashcard app that teaches early words through simple picture association. 📸✨ Built in SwiftUI and designed to grow with my daughter Lily. 🌱

## Brief description 📝
Earlily is an engaging, interactive learning tool for toddlers, helping them learn new words through the power of visual association. Designed with simplicity and accessibility in mind, Earlily offers a delightful learning experience for young minds.

## ✨ Features
- 🌱 Intuitive SwiftUI design tailored for toddlers
- 🎯 Customizable flashcards for adding your own images and words
- 🔍 Interactive game mode with rewards for successful matches
- 🌍 Multilingual support for expanding a child's vocabulary
- 📊 Analytics to track learning progress over time

## 🚀 Installation
To get started, follow these steps:

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/Earlily.git
   ```
2. Navigate into the project directory:
   ```
   cd Earlily
   ```
3. Open the project in Xcode and build for your iOS device or Simulator.

## 💻 Usage
struct Flashcard: View {
    var word: String
    var image: Image

    // ... (rest of the code)
}

// To create a new flashcard, instantiate the Flashcard struct with your custom data:
let myFlashcard = Flashcard(word: "Cat", image: Image("cat.png"))

## 🤝 Contributing
We welcome contributions from everyone! Please take a moment to review our [Contributing Guide](CONTRIBUTING.md) for more information on how to contribute.

## 📄 License
Earlily is released under the MIT License. See [LICENSE](LICENSE) for details.