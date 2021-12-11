//
//  Settings.swift
//  MoodTracker
//
//  Created by Trofim Petyanov on 04.12.2021.
//

import Foundation

struct Settings {
    // Keys for saving data
    enum Setting {
        static let moods = "moods"
        static let activities = "activities"
        static let entries = "entries"
    }
    
    // Data
    var moods: [Mood] {
        get {
            return unarchiveJSON(key: Setting.moods) ?? [Mood(name: "Sad", emoji: "😢", color: Color(hue: 0.7, saturation: 0.7, brightness: 0.7))]
        } set {
            archiveJSON(value: newValue, key: Setting.moods)
        }
    }
    
    var activities: [Activity] {
        get {
            return unarchiveJSON(key: Setting.activities) ?? [Activity(name: "Biking", emoji: "🚴‍♀️"), Activity(name: "Dancing", emoji: "💃"), Activity(name: "Skating", emoji: "🛹"), Activity(name: "Family", emoji: "🏡"), Activity(name: "Friends", emoji: "🫂"), Activity(name: "Cooking", emoji: "🍳"), Activity(name: "Coding", emoji: "💻")]
        } set {
            archiveJSON(value: newValue, key: Setting.activities)
        }
    }
    
    var entries: [Entry] {
        get {
            return unarchiveJSON(key: Setting.entries) ?? []
        } set {
            archiveJSON(value: newValue, key: Setting.entries)
        }
    }
    
    static var shared = Settings()
    private let defaults = UserDefaults.standard
    
    // Encoding and Decoding
    func archiveJSON<T: Encodable>(value: T, key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            let string = String(data: data, encoding: .utf8)
            defaults.set(string, forKey: key)
        } catch {
            debugPrint("Error occured when encoding data")
        }
    }
    
    func unarchiveJSON<T: Decodable>(key: String) -> T? {
        guard let string = defaults.string(forKey: key), let data = string.data(using: .utf8) else { return nil }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            debugPrint("Error occured when decoding data")
            return nil
        }
    }
}
