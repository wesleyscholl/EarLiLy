//
//  FlashcardView.swift
//  EarLiLy
//
//  Interactive flashcard with flip animation
//

import SwiftUI

// Helper function to load images from the Images folder in the bundle
func loadImageFromBundle(named imageName: String) -> UIImage? {
    // Debug: Print what we're looking for
    print("🔍 Looking for image: \(imageName)")
    
    // Try direct path in bundle (Images is copied as folder reference)
    if let resourcePath = Bundle.main.resourcePath {
        let imagePath = resourcePath + "/Images/" + imageName + ".png"
        print("   Trying path: \(imagePath)")
        
        if FileManager.default.fileExists(atPath: imagePath),
           let image = UIImage(contentsOfFile: imagePath) {
            print("   ✅ Found image at: \(imagePath)")
            return image
        }
    }
    
    // Try with bundle path method
    if let imagePath = Bundle.main.path(forResource: imageName, ofType: "png", inDirectory: "Images"),
       let image = UIImage(contentsOfFile: imagePath) {
        print("   ✅ Found with bundle.path in Images directory")
        return image
    }
    
    // Try without subdirectory
    if let imagePath = Bundle.main.path(forResource: imageName, ofType: "png"),
       let image = UIImage(contentsOfFile: imagePath) {
        print("   ✅ Found with bundle.path at root")
        return image
    }
    
    print("   ❌ Image not found")
    return nil
}

struct FlashcardView: View {
    let flashcard: Flashcard
    @State private var isFlipped = false
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            // Back side (word) - starts rotated 180°
            CardSide(isVisible: isFlipped) {
                VStack(spacing: 20) {
                    Text(flashcard.word)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(flashcard.category.icon)
                        .font(.system(size: 40))
                }
            }
            .rotation3DEffect(.degrees(180 + rotation), axis: (x: 0, y: 1, z: 0))
            
            // Front side (image) - starts at 0°
            CardSide(isVisible: !isFlipped) {
                VStack(spacing: 16) {
                    // Load actual image from Images directory in bundle
                    if let uiImage = loadImageFromBundle(named: flashcard.imageName) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 280, height: 280)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            )
                            .padding(10)
                    } else {
                        // Fallback if image not found
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [flashcard.category.color.opacity(0.6), flashcard.category.color]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 250, height: 250)
                            
                            Text(flashcard.category.icon)
                                .font(.system(size: 100))
                            
                            Text("Image not found")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                                .padding(.top, 180)
                        }
                    }
                    
                    Text("Tap to reveal")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
        }
        .frame(width: 300, height: 450)
        .onTapGesture {
            // Haptic feedback on tap
            let impactLight = UIImpactFeedbackGenerator(style: .light)
            impactLight.impactOccurred()
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isFlipped.toggle()
                rotation += 180
            }
        }
    }
}

struct CardSide<Content: View>: View {
    let isVisible: Bool
    @ViewBuilder let content: Content
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.purple, .pink]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .purple.opacity(0.4), radius: 20, x: 0, y: 10)
            
            content
        }
        .opacity(isVisible ? 1 : 0)
    }
}

#Preview {
    FlashcardView(flashcard: Flashcard.sampleData[0])
        .padding()
}
