//
//  FlashcardView.swift
//  EarLiLy
//
//  Interactive flashcard with flip animation
//

import SwiftUI

struct FlashcardView: View {
    let flashcard: Flashcard
    @State private var isFlipped = false
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            // Back side (word)
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
            .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
            
            // Front side (image)
            CardSide(isVisible: !isFlipped) {
                VStack(spacing: 16) {
                    // Placeholder for image - in production, load actual images
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [flashcard.category.color.opacity(0.6), flashcard.category.color]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 200, height: 200)
                        
                        Text(flashcard.category.icon)
                            .font(.system(size: 100))
                    }
                    
                    Text("Tap to reveal")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .rotation3DEffect(.degrees(rotation + 180), axis: (x: 0, y: 1, z: 0))
        }
        .frame(width: 300, height: 450)
        .onTapGesture {
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
