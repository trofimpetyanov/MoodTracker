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
            case entry
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
    
    func updateCollectionView() {
        var snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>()
        
        snapshot.appendSections([.entry])
        snapshot.appendItems([.activity], toSection: .entry)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            
            switch itemIdentifier {
            case .mood:
                return nil
            case .activity:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivitiesCollectionViewCell.reuseIdentifier, for: indexPath) as! ActivitiesCollectionViewCell
                
                cell.configureCell()
                
                return cell
            }
        }
        
        return dataSource
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let padding: CGFloat = 16
        let spacing: CGFloat = 8
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .fractionalHeight(28/100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: padding, bottom: spacing, trailing: padding)
            
            section.orthogonalScrollingBehavior = .groupPaging
            
            return section
        }
        
        return layout
    }
}
