//
//  TodayCollectionViewController.swift
//  MoodTracker
//
//  Created by Trofim Petyanov on 14.11.2021.
//

import UIKit

class TodayCollectionViewController: UICollectionViewController {
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
    
    // MARK: – ViewModel
    enum ViewModel {
        enum Section: Hashable {
            case entries
            case moodCounts
        }
        
        enum Item: Hashable {
            case mood
            case activity
        }
    }
    
    struct Model {
        var moods: [Mood] {
            Settings.shared.moods
        }
        
        var activites: [Activity] {
            Settings.shared.activities
        }
        
        var entries: [Entry] {
            Settings.shared.entries
        }
    }
    
    var model = Model()
    var dataSource: DataSourceType!
    
    // MARK: – Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
        
        updateCollectionView()
    }
    
    //MARK: – Update Methods
    func updateCollectionView() {
        var snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>()
        
        let mo
        
        snapshot.appendSections([.entries, .moodCounts])
        snapshot.appendItems([.mood, .activity], toSection: .entries)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    //MARK: – Actions
    
    //MARK: – Data Source
    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            
            switch itemIdentifier {
            case .mood:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoodsCollectionViewCell.reuseIdentifier, for: indexPath) as! MoodsCollectionViewCell
                
                cell.configureCell()
                
                return cell
            case .activity:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivitiesCollectionViewCell.reuseIdentifier, for: indexPath) as! ActivitiesCollectionViewCell
                
                cell.configureCell()
                
                return cell
            }
        }
        
        return dataSource
    }
    
    //MARK: – Layout
    func createLayout() -> UICollectionViewCompositionalLayout {
        let padding: CGFloat = 16
        let spacing: CGFloat = 8
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            
            switch self.dataSource.snapshot().sectionIdentifiers[sectionIndex] {
            case .entries:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(230))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = spacing
                section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: padding, bottom: spacing, trailing: padding)
                
                section.orthogonalScrollingBehavior = .groupPaging
                
                return section
            case .moodCounts:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = spacing
                section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: padding, bottom: spacing, trailing: padding)
                
                section.orthogonalScrollingBehavior = .groupPaging
                
                return section
            }

        }
        
        return layout
    }
}
