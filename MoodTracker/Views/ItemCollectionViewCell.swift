//
//  ItemCollectionViewCell.swift
//  MoodTracker
//
//  Created by Trofim Petyanov on 07.12.2021.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "itemCell"
    
    @IBOutlet var emojiLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    func configureCell(with emoji: String, and name: String) {
        emojiLabel.text = emoji
        nameLabel.text = name
        
        layer.cornerRadius = 8
    }
}
