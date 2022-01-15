//
//  MoodsCollectionViewCell.swift
//  MoodTracker
//
//  Created by Trofim Petyanov on 11.12.2021.
//

import UIKit

class MoodsCollectionViewCell: UICollectionViewCell {
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
    
    static let reuseIdentifier = "moodsCell"
    
    //MARK: – Outlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var slider: MoodSlider!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var saveButton: UIButton!
    
    //MARK: – View Model
    enum ViewModel {
        enum Section: Hashable {
            case items
        }
        
        enum Item: Hashable {
            case mood(_ mood: Mood)
        }
    }
    
    struct Model {
        var moods: [Mood] {
            Settings.shared.moods
        }
        
        var selectedMoodID: Int {
            Settings.shared.selectedMoodID
        }
    }
    
    var dataSource: DataSourceType!
    var model = Model()
    
    var selectedMoodID: Int!
    
    //MARK: – Helper Methods
    func configureCell() {
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
        
        updateCollectionView()
        
        layer.cornerRadius = 8
        collectionView.layer.cornerRadius = 8
        saveButton.layer.cornerRadius = saveButton.layer.bounds.height / 2
        
        //Setting up the default mood
        selectedMoodID = model.selectedMoodID
        
        updateCell()
        updateSliderValue()
    }
    
    func applySnapshot(using items: [ViewModel.Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>()
        
        snapshot.appendSections([.items])
        snapshot.appendItems(items, toSection: .items)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    //MARK: – Update Methods
    func updateCollectionView() {
        let items = model.moods.reduce(into: [ViewModel.Item]()) { partialResult, mood in
            let item = ViewModel.Item.mood(mood)
            
            partialResult.append(item)
        }
        
        applySnapshot(using: items)
    }
    
    func updateCell() {
        let mood = self.model.moods[selectedMoodID]
        let color = mood.color.uiColor
        
        UIView.animate(withDuration: 0.2) {
            self.tintColor = color.withAlphaComponent(0.5)
            self.slider.tintColor = color
            self.infoLabel.text = "I feel \(mood.name.lowercased())"
        }
    }
    
    func updateSliderValue() {
        slider.setValue(Float(selectedMoodID), animated: true)
    }
    
    //MARK: – Actions
    @IBAction func sliderValueSet(_ sender: MoodSlider) {
        let sliderValue = slider.value
        
        switch sliderValue {
        case 0.0...0.6:
            selectedMoodID = 0
        case 0.6...1.6:
            selectedMoodID = 1
        case 1.6...2.6:
            selectedMoodID = 2
        case 2.6...3.4:
            selectedMoodID = 3
        case 3.4...4.0:
            selectedMoodID = 4
        default:
            break
        }
        
        updateCell()
        updateSliderValue()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        var entries = Settings.shared.entries
        let selectedMood = model.moods[selectedMoodID]
        
        if var lastEntry = entries.last, Calendar(identifier: .gregorian).isDateInToday(lastEntry.date) {
            lastEntry.mood = selectedMood
            
            entries.removeLast()
            entries.append(lastEntry)
        } else {
            let newEntry = Entry(date: Date(), mood: selectedMood, activities: nil)
            entries.append(newEntry)
        }
        
        Settings.shared.entries = entries
        Settings.shared.selectedMoodID = self.selectedMoodID
        
        self.saveButton.setTitle("SAVED!", for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.saveButton.setTitle("SAVE", for: .normal)
        }

    }
    
    // MARK: – Data Source
    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.reuseIdentifier, for: indexPath) as! ItemCollectionViewCell
            
            switch itemIdentifier {
            case .mood(let mood):
                cell.configureCell(with: mood.emoji, and: nil, for: .moods)
            }
            
            return cell
        }
        
        return dataSource
    }
    
    // MARK: – Layout
    func createLayout() -> UICollectionViewCompositionalLayout {
        let spacing: CGFloat = 8
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/5))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 5)
            group.interItemSpacing = .fixed(spacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
            
            return section
        }
        
        return layout
    }
}
