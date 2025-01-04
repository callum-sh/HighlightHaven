//
//  HighlightModel.swift
//  HighlightHaven
//
//  Created by callum on 2025-01-01.
//

import Foundation

struct Highlight: Identifiable, Codable {
    let id: UUID
    let text: String
    let book: String
    let author: String
    
    init(id: UUID = UUID(), text: String, book: String, author: String) {
        self.id = id
        self.text = text
        self.book = book
        self.author = author
    }
}
