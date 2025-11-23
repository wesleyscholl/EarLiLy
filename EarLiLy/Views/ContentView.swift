//
//  ContentView.swift
//  EarLiLy
//
//  Main navigation hub with delightful animations
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: FlashcardStore
    @State private var selectedTab = 0
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity)
                    .zIndex(1)
            } else {
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem {
                            Label("Learn", systemImage: "book.fill")
                        }
                        .tag(0)
                    
                    GameView()
                        .tabItem {
                            Label("Play", systemImage: "gamecontroller.fill")
                        }
                        .tag(1)
                    
                    ProgressView()
                        .tabItem {
                            Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                        }
                        .tag(2)
                }
                .accentColor(.purple)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
    }
}

// MARK: - Splash View
struct SplashView: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.purple.opacity(0.6), .pink.opacity(0.6), .orange.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("🌼")
                    .font(.system(size: 100))
                    .scaleEffect(scale)
                    .rotationEffect(.degrees(scale == 0.5 ? 0 : 360))
                
                Text("EarLiLy")
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
            }
            withAnimation(.easeIn(duration: 0.5).delay(0.3)) {
                opacity = 1.0
            }
        }
    }
}

// MARK: - Home View
struct HomeView: View {
    @EnvironmentObject var store: FlashcardStore
    @State private var selectedCategory: Flashcard.Category?
    @State private var showingAddCard = false
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Gradient background
                LinearGradient(
                    gradient: Gradient(colors: [.purple.opacity(0.1), .pink.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Welcome header
                        VStack(spacing: 8) {
                            Text("Hello, Lily! 👋")
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Text("What do you want to learn today?")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 20)
                        
                        // Category grid
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(Flashcard.Category.allCases, id: \.self) { category in
                                Button {
                                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred()
                                    selectedCategory = category
                                } label: {
                                    CategoryCard(category: category)
                                }
                                .buttonStyle(PressableButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Learn")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddCard = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.purple)
                    }
                }
            }
            .fullScreenCover(item: $selectedCategory) { category in
                FlashcardListView(category: category)
            }
            .sheet(isPresented: $showingAddCard) {
                AddFlashcardView()
            }
        }
    }
}

// MARK: - Category Card
struct CategoryCard: View {
    let category: Flashcard.Category
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 12) {
            Text(category.icon)
                .font(.system(size: 60))
            
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
    }
}

// MARK: - Pressable Button Style
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Flashcard List View
struct FlashcardListView: View {
    @EnvironmentObject var store: FlashcardStore
    @Environment(\.dismiss) var dismiss
    let category: Flashcard.Category
    @State private var currentIndex = 0
    @State private var offset: CGFloat = 0
    @State private var rotation: Double = 0
    
    private var flashcards: [Flashcard] {
        store.getFlashcards(for: category)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [category.color.opacity(0.2), .white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                if flashcards.isEmpty {
                    EmptyStateView(category: category)
                } else {
                    VStack {
                        Spacer()
                        
                        ZStack {
                            ForEach(Array(flashcards.enumerated()), id: \.element.id) { index, card in
                                if index >= currentIndex && index < currentIndex + 3 {
                                    FlashcardView(flashcard: card)
                                        .offset(x: index == currentIndex ? offset : 0)
                                        .rotationEffect(.degrees(index == currentIndex ? rotation : 0))
                                        .scaleEffect(index == currentIndex ? 1.0 : 0.9 - CGFloat(index - currentIndex) * 0.05)
                                        .offset(y: CGFloat(index - currentIndex) * 10)
                                        .zIndex(Double(flashcards.count - index))
                                        .gesture(
                                            DragGesture()
                                                .onChanged { value in
                                                    if index == currentIndex {
                                                        offset = value.translation.width
                                                        rotation = Double(value.translation.width / 20)
                                                    }
                                                }
                                                .onEnded { value in
                                                    if index == currentIndex {
                                                        if abs(value.translation.width) > 100 {
                                                            withAnimation(.spring()) {
                                                                offset = value.translation.width > 0 ? 500 : -500
                                                            }
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                                currentIndex = min(currentIndex + 1, flashcards.count - 1)
                                                                offset = 0
                                                                rotation = 0
                                                            }
                                                        } else {
                                                            withAnimation(.spring()) {
                                                                offset = 0
                                                                rotation = 0
                                                            }
                                                        }
                                                    }
                                                }
                                        )
                                }
                            }
                        }
                        .frame(height: 500)
                        
                        Spacer()
                        
                        // Progress indicator
                        HStack(spacing: 8) {
                            ForEach(0..<flashcards.count, id: \.self) { index in
                                Circle()
                                    .fill(index <= currentIndex ? category.color : Color.gray.opacity(0.3))
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(index == currentIndex ? 1.5 : 1.0)
                                    .animation(.spring(), value: currentIndex)
                            }
                        }
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle(category.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let category: Flashcard.Category
    
    var body: some View {
        VStack(spacing: 20) {
            Text(category.icon)
                .font(.system(size: 80))
            
            Text("No flashcards yet!")
                .font(.system(size: 24, weight: .bold, design: .rounded))
            
            Text("Add some flashcards to get started")
                .font(.system(size: 16, design: .rounded))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Add Flashcard View
struct AddFlashcardView: View {
    @EnvironmentObject var store: FlashcardStore
    @Environment(\.dismiss) var dismiss
    @State private var word = ""
    @State private var imageName = ""
    @State private var selectedCategory: Flashcard.Category = .animals
    
    var body: some View {
        NavigationView {
            Form {
                Section("Word") {
                    TextField("Enter word", text: $word)
                }
                
                Section("Image") {
                    TextField("Image name", text: $imageName)
                }
                
                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Flashcard.Category.allCases, id: \.self) { category in
                            Text("\(category.icon) \(category.rawValue)").tag(category)
                        }
                    }
                }
            }
            .navigationTitle("Add Flashcard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let flashcard = Flashcard(
                            word: word,
                            imageName: imageName,
                            category: selectedCategory
                        )
                        store.addFlashcard(flashcard)
                        dismiss()
                    }
                    .disabled(word.isEmpty || imageName.isEmpty)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(FlashcardStore())
}
