//
//  Color.swift
//  MoodTracker
//
//  Created by Trofim Petyanov on 14.11.2021.
//

import Foundation
import UIKit

struct Color {
    var hue: Double
    var saturation: Double
    var brightness: Double
}

extension Color {
    var uiColor: UIColor {
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}

extension Color: Codable { }
