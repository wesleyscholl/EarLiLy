//
//  GameView.swift
//  EarLiLy
//
//  Interactive matching game with rewards and celebrations
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var store: FlashcardStore
    @State private var selectedCategory: Flashcard.Category?
    @State private var isPlaying = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.1), .green.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if !isPlaying {
                    CategorySelectionView(selectedCategory: $selectedCategory, isPlaying: $isPlaying)
                } else if let category = selectedCategory {
                    MatchingGameView(category: category, isPlaying: $isPlaying)
                }
            }
            .navigationTitle("Play & Learn")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Category Selection
struct CategorySelectionView: View {
    @Binding var selectedCategory: Flashcard.Category?
    @Binding var isPlaying: Bool
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text("🎮")
                        .font(.system(size: 80))
                        .pulse()
                    
                    Text("Let's Play!")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                    
                    Text("Pick a category to start")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(Flashcard.Category.allCases, id: \.self) { category in
                        GameCategoryCard(category: category)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    selectedCategory = category
                                    isPlaying = true
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
    }
}

struct GameCategoryCard: View {
    let category: Flashcard.Category
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 12) {
            Text(category.icon)
                .font(.system(size: 60))
                .scaleEffect(isPressed ? 1.2 : 1.0)
            
            Text(category.rawValue)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .frame(height: 140)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [category.color, category.color.opacity(0.7)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: category.color.opacity(0.4), radius: 8, x: 0, y: 4)
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, pressing: { pressing in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = pressing
            }
        }) {}
    }
}

// MARK: - Matching Game
struct MatchingGameView: View {
    @EnvironmentObject var store: FlashcardStore
    let category: Flashcard.Category
    @Binding var isPlaying: Bool
    
    @State private var gameCards: [GameCard] = []
    @State private var selectedCards: [GameCard] = []
    @State private var matchedCards: Set<UUID> = []
    @State private var score = 0
    @State private var moves = 0
    @State private var showConfetti = false
    @State private var showGameOver = false
    @State private var wrongGuess = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // Score header
                HStack {
                    Button(action: { isPlaying = false }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.title)
                            .foregroundColor(category.color)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("Score")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(score)")
                            .font(.title2.bold())
                            .foregroundColor(category.color)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("Moves")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(moves)")
                            .font(.title2.bold())
                            .foregroundColor(category.color)
                    }
                }
                .padding(.horizontal)
                
                // Game grid
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(gameCards) { card in
                        GameCardView(
                            card: card,
                            isFlipped: selectedCards.contains(card) || matchedCards.contains(card.id),
                            isMatched: matchedCards.contains(card.id),
                            color: category.color
                        )
                        .onTapGesture {
                            handleCardTap(card)
                        }
                        .wiggle(trigger: wrongGuess && selectedCards.contains(card))
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Restart button
                Button(action: startNewGame) {
                    Text("New Game")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(category.color)
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            
            if showConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            startNewGame()
        }
        .alert("Great Job! 🎉", isPresented: $showGameOver) {
            Button("Play Again") {
                startNewGame()
            }
            Button("Back") {
                isPlaying = false
            }
        } message: {
            Text("You completed the game in \(moves) moves!\nScore: \(score)")
        }
    }
    
    private func startNewGame() {
        let flashcards = store.getRandomFlashcards(count: 6, category: category)
        var cards: [GameCard] = []
        
        for flashcard in flashcards {
            cards.append(GameCard(flashcard: flashcard, type: .word))
            cards.append(GameCard(flashcard: flashcard, type: .image))
        }
        
        gameCards = cards.shuffled()
        selectedCards = []
        matchedCards = []
        score = 0
        moves = 0
        showGameOver = false
        wrongGuess = false
    }
    
    private func handleCardTap(_ card: GameCard) {
        guard !matchedCards.contains(card.id),
              !selectedCards.contains(card),
              selectedCards.count < 2 else { return }
        
        selectedCards.append(card)
        
        if selectedCards.count == 2 {
            moves += 1
            checkForMatch()
        }
    }
    
    private func checkForMatch() {
        guard selectedCards.count == 2 else { return }
        
        let first = selectedCards[0]
        let second = selectedCards[1]
        
        if first.flashcard.id == second.flashcard.id && first.type != second.type {
            // Match found!
            withAnimation(.spring()) {
                matchedCards.insert(first.id)
                matchedCards.insert(second.id)
                score += 10
            }
            
            store.recordAnswer(for: first.flashcard, isCorrect: true)
            
            showConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showConfetti = false
            }
            
            selectedCards = []
            
            // Check for game over
            if matchedCards.count == gameCards.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    store.totalGamesPlayed += 1
                    showGameOver = true
                }
            }
        } else {
            // No match
            wrongGuess = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    selectedCards = []
                    wrongGuess = false
                }
            }
        }
    }
}

// MARK: - Game Card Model
struct GameCard: Identifiable, Equatable {
    let id = UUID()
    let flashcard: Flashcard
    let type: CardType
    
    enum CardType {
        case word
        case image
    }
    
    static func == (lhs: GameCard, rhs: GameCard) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Game Card View
struct GameCardView: View {
    let card: GameCard
    let isFlipped: Bool
    let isMatched: Bool
    let color: Color
    
    var body: some View {
        ZStack {
            if isFlipped {
                // Front (content)
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [color, color.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    if card.type == .word {
                        Text(card.flashcard.word)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(8)
                    } else {
                        Text(card.flashcard.category.icon)
                            .font(.system(size: 50))
                    }
                    
                    if isMatched {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.green, lineWidth: 4)
                    }
                }
            } else {
                // Back
                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.gray.opacity(0.3), .gray.opacity(0.5)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("?")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .frame(height: 100)
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isFlipped)
        .scaleEffect(isMatched ? 1.05 : 1.0)
        .opacity(isMatched ? 0.8 : 1.0)
    }
}

#Preview {
    GameView()
        .environmentObject(FlashcardStore())
}
