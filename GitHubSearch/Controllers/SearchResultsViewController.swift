//
//  SearchResultsViewController.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 13.01.2021.
//

import UIKit

class SearchResultsViewController: UIViewController {
    typealias CollectionDataSource = UICollectionViewDiffableDataSource<Section, User>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, User>
    
    enum Section {
        case main
    }
    
    weak var coordinator: MainCoordinator?
    var collectionView: UICollectionView!
    var dataSource: CollectionDataSource!
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = "Search results for: \(username ?? "")"
        
        configureCollectionView()
        configureDataSource()
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .white
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UserCollectionViewCell, User> { cell, _, user in
            let content = UserCellContentConfiguration(userLogin: user.login)
            cell.contentConfiguration = content
        }
        
        dataSource = CollectionDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: user)
        })
        
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        
        let searchRequest = UserSearchRequest(query: username)
        searchRequest.search { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let users):
                snapshot.appendItems(users)
                DispatchQueue.main.async { [weak self] in
                    self?.dataSource.apply(snapshot, animatingDifferences: false)
                }
            }
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSIze = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSIze, subitem: item, count: 3)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(8.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension SearchResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = dataSource.itemIdentifier(for: indexPath) else { return }
        coordinator?.showUserDetails(for: user)
    }
}
