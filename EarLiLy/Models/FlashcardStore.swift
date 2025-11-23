//
//  FlashcardStore.swift
//  EarLiLy
//
//  Manages flashcard data and persistence
//

import Foundation
import SwiftUI

@MainActor
class FlashcardStore: ObservableObject {
    @Published var flashcards: [Flashcard] = []
    @Published var selectedLanguage: String = "en"
    @Published var totalGamesPlayed: Int = 0
    @Published var totalCorrectAnswers: Int = 0
    @Published var currentStreak: Int = 0
    @Published var longestStreak: Int = 0
    
    private let flashcardsKey = "flashcards"
    private let statsKey = "statistics"
    
    init() {
        loadFlashcards()
        loadStatistics()
    }
    
    // MARK: - Dynamic Image Loading
    
    static func loadFlashcardsFromImages() -> [Flashcard] {
        var flashcards: [Flashcard] = []
        
        // Debug: Print bundle resource path
        if let resourcePath = Bundle.main.resourcePath {
            print("📦 Bundle resource path: \(resourcePath)")
            
            // Check if Images directory exists
            let imagesPath = resourcePath + "/Images"
            if FileManager.default.fileExists(atPath: imagesPath) {
                print("✅ Images directory exists at: \(imagesPath)")
            } else {
                print("❌ Images directory NOT found at: \(imagesPath)")
            }
        }
        
        let categories: [(Flashcard.Category, String)] = [
            (.animals, "Animals"),
            (.food, "Food"),
            (.objects, "Objects")
        ]
        
        for (category, directoryName) in categories {
            if let resourcePath = Bundle.main.resourcePath {
                let categoryPath = resourcePath + "/Images/\(directoryName)"
                print("🔍 Checking category: \(directoryName) at \(categoryPath)")
                
                if let enumerator = FileManager.default.enumerator(atPath: categoryPath) {
                    var count = 0
                    while let filename = enumerator.nextObject() as? String {
                        if filename.hasSuffix(".png") {
                            count += 1
                            // Remove .png extension
                            let nameWithoutExtension = filename.replacingOccurrences(of: ".png", with: "")
                            
                            // Capitalize first letter and format word
                            let word = nameWithoutExtension.prefix(1).uppercased() + nameWithoutExtension.dropFirst()
                            
                            let imageName = "\(directoryName)/\(nameWithoutExtension)"
                            
                            print("   📸 Found: \(filename) -> Word: '\(word)', ImageName: '\(imageName)'")
                            
                            let flashcard = Flashcard(
                                word: word,
                                imageName: imageName,
                                category: category,
                                difficulty: .easy
                            )
                            flashcards.append(flashcard)
                        }
                    }
                    print("   Total images in \(directoryName): \(count)")
                }
            }
        }
        
        print("📊 Total flashcards loaded: \(flashcards.count)")
        return flashcards.sorted { $0.word < $1.word }
    }
    
    // MARK: - Flashcard Management
    
    func addFlashcard(_ flashcard: Flashcard) {
        flashcards.append(flashcard)
        saveFlashcards()
    }
    
    func updateFlashcard(_ flashcard: Flashcard) {
        if let index = flashcards.firstIndex(where: { $0.id == flashcard.id }) {
            flashcards[index] = flashcard
            saveFlashcards()
        }
    }
    
    func deleteFlashcard(_ flashcard: Flashcard) {
        flashcards.removeAll { $0.id == flashcard.id }
        saveFlashcards()
    }
    
    func recordAnswer(for flashcard: Flashcard, isCorrect: Bool) {
        var updated = flashcard
        updated.timesShown += 1
        updated.lastShownDate = Date()
        
        if isCorrect {
            updated.timesCorrect += 1
            totalCorrectAnswers += 1
            currentStreak += 1
            
            if currentStreak > longestStreak {
                longestStreak = currentStreak
            }
        } else {
            currentStreak = 0
        }
        
        updateFlashcard(updated)
        saveStatistics()
    }
    
    func getFlashcards(for category: Flashcard.Category? = nil) -> [Flashcard] {
        if let category = category {
            return flashcards.filter { $0.category == category }
        }
        return flashcards
    }
    
    func getRandomFlashcards(count: Int, category: Flashcard.Category? = nil) -> [Flashcard] {
        let filtered = getFlashcards(for: category)
        return Array(filtered.shuffled().prefix(count))
    }
    
    // MARK: - Persistence
    
    private func loadFlashcards() {
        // Always load flashcards dynamically from Images directory
        flashcards = FlashcardStore.loadFlashcardsFromImages()
        
        // Fallback to sample data if no images found
        if flashcards.isEmpty {
            print("⚠️ No images found, falling back to sample data")
            flashcards = Flashcard.sampleData
        }
        
        saveFlashcards()
    }
    
    private func saveFlashcards() {
        if let encoded = try? JSONEncoder().encode(flashcards) {
            UserDefaults.standard.set(encoded, forKey: flashcardsKey)
        }
    }
    
    private func loadStatistics() {
        if let data = UserDefaults.standard.data(forKey: statsKey),
           let decoded = try? JSONDecoder().decode(Statistics.self, from: data) {
            totalGamesPlayed = decoded.totalGamesPlayed
            totalCorrectAnswers = decoded.totalCorrectAnswers
            currentStreak = decoded.currentStreak
            longestStreak = decoded.longestStreak
        }
    }
    
    private func saveStatistics() {
        let stats = Statistics(
            totalGamesPlayed: totalGamesPlayed,
            totalCorrectAnswers: totalCorrectAnswers,
            currentStreak: currentStreak,
            longestStreak: longestStreak
        )
        
        if let encoded = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(encoded, forKey: statsKey)
        }
    }
    
    struct Statistics: Codable {
        var totalGamesPlayed: Int
        var totalCorrectAnswers: Int
        var currentStreak: Int
        var longestStreak: Int
    }
}
