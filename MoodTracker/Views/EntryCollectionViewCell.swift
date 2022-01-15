//
//  EntryCollectionViewCell.swift
//  MoodTracker
//
//  Created by Trofim Petyanov on 11.01.2022.
//

import UIKit

class EntryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var emojiLabel: UILabel!
    @IBOutlet var moodLabel: UILabel!
    @IBOutlet var activitiesLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    private func formateDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        return dateFormatter.string(from: date)
    }
    
    func configureCell(with entry: Entry) {
        emojiLabel.text = entry.mood?.emoji
        moodLabel.text = entry.mood?.name
        
        if let activities = entry.activities {
            activitiesLabel.text = activities.reduce("", { reuslt, activity in reuslt + activity.emoji })
        }
        
        dateLabel.text = formateDate(entry.date)
        
        layer.cornerRadius = 8
    }
}
