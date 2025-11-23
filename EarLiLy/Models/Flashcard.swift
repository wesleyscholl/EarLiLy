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
    
    enum Category: String, Codable, CaseIterable, Identifiable {
        case animals = "Animals"
        case food = "Food"
        case objects = "Objects"
        case colors = "Colors"
        case numbers = "Numbers"
        case shapes = "Shapes"
        case family = "Family"
        case toys = "Toys"
        case nature = "Nature"
        
        var id: String { self.rawValue }
        
        var icon: String {
            switch self {
            case .animals: return "🐾"
            case .food: return "🍎"
            case .objects: return "🎯"
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
            case .objects: return .indigo
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
        // Animals
        Flashcard(
            word: "Tiger",
            imageName: "Animals/tiger",
            translations: ["es": "Tigre", "fr": "Tigre"],
            category: .animals,
            difficulty: .easy
        ),
        Flashcard(
            word: "Zebra",
            imageName: "Animals/zebra",
            translations: ["es": "Cebra", "fr": "Zèbre"],
            category: .animals,
            difficulty: .easy
        ),
        Flashcard(
            word: "Turkey",
            imageName: "Animals/turkey",
            translations: ["es": "Pavo", "fr": "Dinde"],
            category: .animals,
            difficulty: .easy
        ),
        Flashcard(
            word: "Turtle",
            imageName: "Animals/turtle",
            translations: ["es": "Tortuga", "fr": "Tortue"],
            category: .animals,
            difficulty: .easy
        ),
        Flashcard(
            word: "Whale",
            imageName: "Animals/whale",
            translations: ["es": "Ballena", "fr": "Baleine"],
            category: .animals,
            difficulty: .easy
        ),
        
        // Food
        Flashcard(
            word: "Pumpkin",
            imageName: "Food/pumpkin",
            translations: ["es": "Calabaza", "fr": "Citrouille"],
            category: .food,
            difficulty: .easy
        ),
        Flashcard(
            word: "Strawberry",
            imageName: "Food/strawberry",
            translations: ["es": "Fresa", "fr": "Fraise"],
            category: .food,
            difficulty: .easy
        ),
        Flashcard(
            word: "Watermelon",
            imageName: "Food/watermelon",
            translations: ["es": "Sandía", "fr": "Pastèque"],
            category: .food,
            difficulty: .easy
        ),
        Flashcard(
            word: "Pepper",
            imageName: "Food/pepper",
            translations: ["es": "Pimiento", "fr": "Poivron"],
            category: .food,
            difficulty: .easy
        ),
        Flashcard(
            word: "Tomato",
            imageName: "Food/tomato",
            translations: ["es": "Tomate", "fr": "Tomate"],
            category: .food,
            difficulty: .easy
        ),
        
        // Objects
        Flashcard(
            word: "Wand",
            imageName: "Objects/wand",
            translations: ["es": "Varita", "fr": "Baguette"],
            category: .objects,
            difficulty: .easy
        ),
        Flashcard(
            word: "Xylophone",
            imageName: "Objects/xylophone",
            translations: ["es": "Xilófono", "fr": "Xylophone"],
            category: .objects,
            difficulty: .easy
        ),
        Flashcard(
            word: "Violin",
            imageName: "Objects/violin",
            translations: ["es": "Violín", "fr": "Violon"],
            category: .objects,
            difficulty: .easy
        ),
        Flashcard(
            word: "Yo-Yo",
            imageName: "Objects/yo-yo",
            translations: ["es": "Yoyó", "fr": "Yoyo"],
            category: .objects,
            difficulty: .easy
        ),
        Flashcard(
            word: "World",
            imageName: "Objects/world",
            translations: ["es": "Mundo", "fr": "Monde"],
            category: .objects,
            difficulty: .easy
        )
    ]
}
