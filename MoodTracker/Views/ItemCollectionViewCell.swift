//
//  ItemCollectionViewCell.swift
//  MoodTracker
//
//  Created by Trofim Petyanov on 07.12.2021.
//

import UIKit

enum CellType {
    case moods, activites
}

class ItemCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "itemCell"
    
    @IBOutlet var emojiLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    func configureCell(with emoji: String, and name: String?, for cellType: CellType) {
        emojiLabel.text = emoji
        
        switch cellType {
        case .moods:
            backgroundColor = .clear
        case .activites:
            nameLabel.text = name!
        }
        
        layer.cornerRadius = 8
    }
}
