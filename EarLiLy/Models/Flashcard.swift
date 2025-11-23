//
//  Flashcard.swift
//  EarLiLy
//
//  Data model for flashcards
//

import Foundation
import SwiftUI

struct Flashcard: Identifiable, Codable, Equatable {
    let id: UUID
    var word: String
    var imageName: String
    var translations: [String: String] // Language code: translation
    var category: Category
    var difficulty: Difficulty
    var timesShown: Int
    var timesCorrect: Int
    var lastShownDate: Date?
    
    init(
        id: UUID = UUID(),
        word: String,
        imageName: String,
        translations: [String: String] = [:],
        category: Category = .animals,
        difficulty: Difficulty = .easy,
        timesShown: Int = 0,
        timesCorrect: Int = 0,
        lastShownDate: Date? = nil
    ) {
        self.id = id
        self.word = word
        self.imageName = imageName
        self.translations = translations
        self.category = category
        self.difficulty = difficulty
        self.timesShown = timesShown
        self.timesCorrect = timesCorrect
        self.lastShownDate = lastShownDate
    }
    
    var successRate: Double {
        guard timesShown > 0 else { return 0 }
        return Double(timesCorrect) / Double(timesShown)
    }
    
    enum Category: String, Codable, CaseIterable {
        case animals = "Animals"
        case food = "Food"
        case colors = "Colors"
        case numbers = "Numbers"
        case shapes = "Shapes"
        case family = "Family"
        case toys = "Toys"
        case nature = "Nature"
        
        var icon: String {
            switch self {
            case .animals: return "🐾"
            case .food: return "🍎"
            case .colors: return "🎨"
            case .numbers: return "🔢"
            case .shapes: return "⭐️"
            case .family: return "👨‍👩‍👧"
            case .toys: return "🧸"
            case .nature: return "🌳"
            }
        }
        
        var color: Color {
            switch self {
            case .animals: return .orange
            case .food: return .red
            case .colors: return .purple
            case .numbers: return .blue
            case .shapes: return .yellow
            case .family: return .pink
            case .toys: return .green
            case .nature: return .mint
            }
        }
    }
    
    enum Difficulty: String, Codable, CaseIterable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
}

// MARK: - Sample Data
extension Flashcard {
    static let sampleData: [Flashcard] = [
        Flashcard(
            word: "Cat",
            imageName: "cat",
            translations: ["es": "Gato", "fr": "Chat"],
            category: .animals,
            difficulty: .easy
        ),
        Flashcard(
            word: "Dog",
            imageName: "dog",
            translations: ["es": "Perro", "fr": "Chien"],
            category: .animals,
            difficulty: .easy
        ),
        Flashcard(
            word: "Apple",
            imageName: "apple",
            translations: ["es": "Manzana", "fr": "Pomme"],
            category: .food,
            difficulty: .easy
        ),
        Flashcard(
            word: "Banana",
            imageName: "banana",
            translations: ["es": "Plátano", "fr": "Banane"],
            category: .food,
            difficulty: .easy
        ),
        Flashcard(
            word: "Red",
            imageName: "red",
            translations: ["es": "Rojo", "fr": "Rouge"],
            category: .colors,
            difficulty: .easy
        ),
        Flashcard(
            word: "Blue",
            imageName: "blue",
            translations: ["es": "Azul", "fr": "Bleu"],
            category: .colors,
            difficulty: .easy
        ),
        Flashcard(
            word: "One",
            imageName: "one",
            translations: ["es": "Uno", "fr": "Un"],
            category: .numbers,
            difficulty: .easy
        ),
        Flashcard(
            word: "Two",
            imageName: "two",
            translations: ["es": "Dos", "fr": "Deux"],
            category: .numbers,
            difficulty: .easy
        )
    ]
}
