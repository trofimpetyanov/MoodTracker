//
//  Entry.swift
//  MoodTracker
//
//  Created by Trofim Petyanov on 14.11.2021.
//

import Foundation

struct Entry {
    var date: Date
    var mood: Mood
    var activities: [Activity]?
}

extension Entry: Codable { }
