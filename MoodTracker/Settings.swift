//
//  Settings.swift
//  MoodTracker
//
//  Created by Trofim Petyanov on 04.12.2021.
//

import Foundation
import UIKit

struct Settings {
    // Keys for saving data
    enum Setting {
        static let moods = "moods"
        static let activities = "activities"
        static let entries = "entries"
        
        static let selectedMood = "selectedMood"
        static let cellColor = "cellColor"
    }
    
    // Data
    var moods: [Mood] {
        get {
            return unarchiveJSON(key: Setting.moods) ?? [
                Mood(name: "Sad", emoji: "😢", color: Color(hue: 0.61, saturation: 0.96, brightness: 1.0)),
                Mood(name: "Angry", emoji: "😠", color: Color(hue: 1.0, saturation: 0.7, brightness: 0.9)),
                Mood(name: "OK", emoji: "😐", color: Color(hue: 0.128, saturation: 0.9, brightness: 0.9)),
                Mood(name: "Great", emoji: "🙂", color: Color(hue: 0.34, saturation: 0.95, brightness: 0.65)),
                Mood(name: "Awesome", emoji: "😁", color: Color(hue: 0.775, saturation: 0.5, brightness: 0.9))
            ]
        } set {
            archiveJSON(value: newValue, key: Setting.moods)
        }
    }
    
    var activities: [Activity] {
        get {
            return unarchiveJSON(key: Setting.activities) ?? [
                Activity(name: "Biking", emoji: "🚴‍♀️"),
                Activity(name: "Dancing", emoji: "💃"),
                Activity(name: "Skating", emoji: "🛹"),
                Activity(name: "Family", emoji: "🏡"),
                Activity(name: "Friends", emoji: "🫂"),
                Activity(name: "Cooking", emoji: "🍳"),
                Activity(name: "Coding", emoji: "💻")
            ]
        } set {
            archiveJSON(value: newValue, key: Setting.activities)
        }
    }
    
    var entries: [Entry] {
        get {
            return unarchiveJSON(key: Setting.entries) ?? []
        } set {
            archiveJSON(value: newValue.sorted { $0.date < $1.date }, key: Setting.entries)
        }
    }
    
    var selectedMoodID: Int {
        get {
            return unarchiveJSON(key: Setting.selectedMood) ?? 3
        } set {
            archiveJSON(value: newValue, key: Setting.selectedMood)
        }
    }
    
    var cellColor: Color {
        get {
            return unarchiveJSON(key: Setting.cellColor) ?? Color(hue: 0, saturation: 0, brightness: 1)
        } set {
            archiveJSON(value: newValue, key: Setting.cellColor)
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
