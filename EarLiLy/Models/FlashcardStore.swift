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
        if let data = UserDefaults.standard.data(forKey: flashcardsKey),
           let decoded = try? JSONDecoder().decode([Flashcard].self, from: data) {
            flashcards = decoded
        } else {
            // Load sample data on first launch
            flashcards = Flashcard.sampleData
            saveFlashcards()
        }
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
