//
//  MoodSlider.swift
//  MoodTracker
//
//  Created by Trofim Petyanov on 11.12.2021.
//

import UIKit

class MoodSlider: UISlider {
    
    // Slider track width
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: bounds.minX, y: bounds.midY)
        return CGRect(origin: point, size: CGSize(width: bounds.width, height: 8))
    }
    
}
