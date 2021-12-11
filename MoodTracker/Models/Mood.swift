//
//  Mood.swift
//  MoodTracker
//
//  Created by Trofim Petyanov on 14.11.2021.
//

import Foundation

struct Mood {
    var name: String
    var emoji: String
    var color: Color
}

extension Mood: Codable { }

extension Mood: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs: Mood, rhs: Mood) -> Bool {
        return lhs.name.lowercased() == rhs.name.lowercased()
    }
}
