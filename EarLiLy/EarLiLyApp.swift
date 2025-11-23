//
//  EarLiLyApp.swift
//  EarLiLy
//
//  A toddler-friendly flashcard learning app 🌼
//

import SwiftUI

@main
struct EarLiLyApp: App {
    @StateObject private var flashcardStore = FlashcardStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(flashcardStore)
        }
    }
}
