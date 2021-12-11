//
//  Activity.swift
//  MoodTracker
//
//  Created by Trofim Petyanov on 14.11.2021.
//

import Foundation

struct Activity {
    var name: String
    var emoji: String
}

extension Activity: Codable { }

extension Activity: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs: Activity, rhs: Activity) -> Bool {
        return lhs.name.lowercased() == rhs.name.lowercased()
    }
}
