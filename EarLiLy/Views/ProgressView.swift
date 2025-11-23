//
//  ProgressView.swift
//  EarLiLy
//
//  Analytics and progress tracking dashboard
//

import SwiftUI
import Charts

struct ProgressView: View {
    @EnvironmentObject var store: FlashcardStore
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.mint.opacity(0.1), .cyan.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Text("🌟")
                                .font(.system(size: 60))
                            
                            Text("Amazing Progress!")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                            
                            Text("Keep up the great work, Lily!")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 20)
                        
                        // Statistics cards
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            StatCard(
                                title: "Games Played",
                                value: "\(store.totalGamesPlayed)",
                                icon: "gamecontroller.fill",
                                color: .blue
                            )
                            
                            StatCard(
                                title: "Correct Answers",
                                value: "\(store.totalCorrectAnswers)",
                                icon: "checkmark.circle.fill",
                                color: .green
                            )
                            
                            StatCard(
                                title: "Current Streak",
                                value: "\(store.currentStreak)",
                                icon: "flame.fill",
                                color: .orange
                            )
                            
                            StatCard(
                                title: "Best Streak",
                                value: "\(store.longestStreak)",
                                icon: "star.fill",
                                color: .yellow
                            )
                        }
                        .padding(.horizontal)
                        
                        // Category breakdown
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Learning by Category")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .padding(.horizontal)
                            
                            ForEach(Flashcard.Category.allCases, id: \.self) { category in
                                CategoryProgressCard(category: category)
                            }
                        }
                        .padding(.top, 8)
                        
                        // Achievement badges
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Achievements")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                AchievementBadge(
                                    title: "First Steps",
                                    icon: "👶",
                                    isUnlocked: store.totalGamesPlayed >= 1,
                                    description: "Play your first game"
                                )
                                
                                AchievementBadge(
                                    title: "Quick Learner",
                                    icon: "🧠",
                                    isUnlocked: store.totalCorrectAnswers >= 10,
                                    description: "Get 10 correct answers"
                                )
                                
                                AchievementBadge(
                                    title: "On Fire",
                                    icon: "🔥",
                                    isUnlocked: store.currentStreak >= 5,
                                    description: "5-answer streak"
                                )
                                
                                AchievementBadge(
                                    title: "Super Star",
                                    icon: "⭐️",
                                    isUnlocked: store.longestStreak >= 10,
                                    description: "10-answer streak"
                                )
                                
                                AchievementBadge(
                                    title: "Dedicated",
                                    icon: "💎",
                                    isUnlocked: store.totalGamesPlayed >= 20,
                                    description: "Play 20 games"
                                )
                                
                                AchievementBadge(
                                    title: "Master",
                                    icon: "👑",
                                    isUnlocked: store.totalCorrectAnswers >= 100,
                                    description: "100 correct answers"
                                )
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top, 8)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Your Progress")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Text(title)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: color.opacity(0.2), radius: 10, x: 0, y: 5)
        )
    }
}

// MARK: - Category Progress Card
struct CategoryProgressCard: View {
    @EnvironmentObject var store: FlashcardStore
    let category: Flashcard.Category
    
    private var flashcards: [Flashcard] {
        store.getFlashcards(for: category)
    }
    
    private var totalShown: Int {
        flashcards.reduce(0) { $0 + $1.timesShown }
    }
    
    private var totalCorrect: Int {
        flashcards.reduce(0) { $0 + $1.timesCorrect }
    }
    
    private var successRate: Double {
        guard totalShown > 0 else { return 0 }
        return Double(totalCorrect) / Double(totalShown)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Category icon
            ZStack {
                Circle()
                    .fill(category.color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Text(category.icon)
                    .font(.system(size: 30))
            }
            
            // Progress info
            VStack(alignment: .leading, spacing: 8) {
                Text(category.rawValue)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                
                HStack(spacing: 12) {
                    Label("\(flashcards.count)", systemImage: "rectangle.stack")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Label("\(totalShown)", systemImage: "eye")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(category.color)
                            .frame(width: geometry.size.width * successRate, height: 8)
                            .animation(.spring(), value: successRate)
                    }
                }
                .frame(height: 8)
            }
            
            Spacer()
            
            // Success percentage
            VStack {
                Text("\(Int(successRate * 100))%")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(category.color)
                
                Text("success")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: category.color.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal)
    }
}

// MARK: - Achievement Badge
struct AchievementBadge: View {
    let title: String
    let icon: String
    let isUnlocked: Bool
    let description: String
    @State private var showDescription = false
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(
                        isUnlocked
                        ? LinearGradient(
                            gradient: Gradient(colors: [.yellow, .orange]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        : LinearGradient(
                            gradient: Gradient(colors: [.gray.opacity(0.3), .gray.opacity(0.3)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 70, height: 70)
                    .shadow(color: isUnlocked ? .yellow.opacity(0.4) : .clear, radius: 8)
                
                Text(icon)
                    .font(.system(size: 35))
                    .grayscale(isUnlocked ? 0 : 1)
                
                if !isUnlocked {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.white)
                        .font(.title3)
                        .offset(x: 20, y: 20)
                }
            }
            .scaleEffect(isUnlocked ? 1.0 : 0.9)
            .onTapGesture {
                showDescription.toggle()
            }
            
            Text(title)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(isUnlocked ? .primary : .secondary)
                .lineLimit(2)
        }
        .alert(title, isPresented: $showDescription) {
            Button("OK") {
                showDescription = false
            }
        } message: {
            Text(description + (isUnlocked ? " ✅" : " 🔒"))
        }
    }
}

#Preview {
    ProgressView()
        .environmentObject(FlashcardStore())
}
