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
    
    init(id: UUID = UUID(), text: String) {
        self.id = id
        self.text = text
    }
}
