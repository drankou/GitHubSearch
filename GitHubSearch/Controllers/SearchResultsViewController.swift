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
    weak var collectionView: UICollectionView!
    var dataSource: CollectionDataSource!
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Search results for: \(username ?? "")"
        
        configureCollectionView()
        configureDataSource()
    }
    
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UserCollectionViewCell, User> { cell, indexPath, user in
            let cellContentConfiguration = UserCellContentConfiguration(username: user.username, userImage: user.image)
            cell.contentConfiguration = cellContentConfiguration
        }
        
        dataSource = CollectionDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: user)
        })
        
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(userList)
        dataSource.apply(snapshot, animatingDifferences: true)
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
    
    var userList = [
        User(id: "1", name: "alex", username: "drankou", email: "email", image: UIImage(named: "user-default.png")!, status: .focusing),
        User(id: "2", name: "alex", username: "drankou", email: "email", image: UIImage(named: "user-default.png")!, status: .focusing),
        User(id: "3", name: "alex", username: "drankou", email: "email", image: UIImage(named: "user-default.png")!, status: .focusing),
        User(id: "4", name: "alex", username: "drankou", email: "email", image: UIImage(named: "user-default.png")!, status: .focusing),
        User(id: "5", name: "alex", username: "drankou", email: "email", image: UIImage(named: "user-default.png")!, status: .focusing),
    ]
}

extension SearchResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = dataSource.itemIdentifier(for: indexPath) else { return }
        coordinator?.showUserDetails(for: user)
    }
}
