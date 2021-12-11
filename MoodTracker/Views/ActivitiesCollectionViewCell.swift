//
//  MoodActivityCollectionViewCell.swift
//  MoodTracker
//
//  Created by Trofim Petyanov on 04.12.2021.
//

import UIKit

enum CellType {
    case moods
    case activities
}

class ActivitiesCollectionViewCell: UICollectionViewCell {
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
    
    static let reuseIdentifier = "activitiesCell"
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var saveButton: UIButton!
    
    enum ViewModel {
        enum Section: Hashable {
            case items
        }
        
        enum Item: Hashable {
            case activity(_ activity: Activity)
        }
    }
    
    struct Model {
        var activities: [Activity] {
            Settings.shared.activities
        }
    }
    
    var cellType: CellType = .moods
    
    var dataSource: DataSourceType!
    var model = Model()
    
    func configureCell() {
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
        
        updateCollectionView()
        
        layer.cornerRadius = 8
        collectionView.layer.cornerRadius = 8
        saveButton.layer.cornerRadius = saveButton.layer.bounds.height / 2
    }
    
    func applySnapshot(using items: [ViewModel.Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>()
        
        snapshot.appendSections([.items])
        snapshot.appendItems(items, toSection: .items)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func updateCollectionView() {
        let items = model.activities.reduce(into: [ViewModel.Item]()) { partialResult, activity in
            let item = ViewModel.Item.activity(activity)
            
            partialResult.append(item)
        }
        
        applySnapshot(using: items)
    }
    
    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.reuseIdentifier, for: indexPath) as! ItemCollectionViewCell
            
            switch itemIdentifier {
            case .activity(let activity):
                cell.configureCell(with: activity.emoji, and: activity.name)
            }
            
            return cell
        }
        
        return dataSource
    }
    
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
