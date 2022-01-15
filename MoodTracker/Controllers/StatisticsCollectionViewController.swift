//
//  StatisticsCollectionViewController.swift
//  MoodTracker
//
//  Created by Trofim Petyanov on 14.11.2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class StatisticsCollectionViewController: UICollectionViewController {
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
    
    enum ViewModel {
        enum Section: Hashable {
            case entries
        }
        
        typealias Item = Entry
    }
    
    struct Model {
        var entries: [Entry] {
            Settings.shared.entries
        }
    }
    
    let model = Model()
    var dataSource: DataSourceType!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCollectionView()
    }
    
    func setup() {
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
        
        updateCollectionView()
    }
    
    func updateCollectionView() {
        applySnapshot()
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>()
        
        let entries = model.entries.sorted { $0.date > $1.date }
        
        snapshot.appendSections([.entries])
        snapshot.appendItems(entries, toSection: .entries)
        
        dataSource.apply(snapshot)
    }
    
    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "entryCell", for: indexPath) as! EntryCollectionViewCell
            
            cell.configureCell(with: itemIdentifier)
            
            return cell
        }
        
        return dataSource
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { section, environment in
            let spacing: CGFloat = 8
            let padding: CGFloat = 20
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            group.interItemSpacing = .fixed(spacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: padding, bottom: spacing, trailing: padding)
            section.interGroupSpacing = spacing
            
            return section
        }
        
        return layout
    }
}
