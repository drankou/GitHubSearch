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
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
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
    
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 15, left: 25, bottom: 20, right: 15)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20

        let width = UIScreen.main.bounds.width / 3 - 30
        layout.itemSize = CGSize(width: width, height: 140)
        
        return layout
    }
}

extension SearchResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = dataSource.itemIdentifier(for: indexPath) else { return }
        coordinator?.showUserDetails(for: user)
    }
}
