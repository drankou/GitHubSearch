//
//  SearchResultsViewController.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 13.01.2021.
//

import UIKit
import Alamofire

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
    
    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Search results for: \(username ?? "")"
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
    }
}


//MARK: UICollectionViewCompositionalLayout configuration
extension SearchResultsViewController {
    private func createLayout() -> UICollectionViewLayout {
        
        let estimatedHeight = CGFloat(250) //estimated height has to be set to both item and group size for automatic dynamic cell sizing (based on content)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSIze = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSIze, subitem: item, count: 3)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

//MARK: Diffable datasource configuration
extension SearchResultsViewController {
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UserCollectionViewCell, User> { cell, indexPath, user in
            var content =  cell.defaultCellConfiguration()
            content.userLogin = user.login
            content.userImage = user.avatarImage
            
            //TODO image loading and caching
//            ImageCache.publicCache.load(url: user.avatarURL! as NSURL, item: user) { [weak self] (fetchedUser, image) in
//                guard let self = self else { return }
//                if let img = image, img != fetchedUser.avatarImage {
//                    var updatedSnapshot = self.dataSource.snapshot()
//                    if let index = updatedSnapshot.indexOfItem(user) {
//                        let user = self.users[index]
//                        user.avatarImage = img
//                        updatedSnapshot.reloadItems([user])
//                        DispatchQueue.main.async {
//                            self.dataSource.apply(updatedSnapshot, animatingDifferences: true)
//                        }
//                    }
//                }
//            }
            
            cell.contentConfiguration = content
        }
        
        dataSource = CollectionDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: user)
        })
        
        self.initialSnapshot()
    }
    
    private func initialSnapshot() {
        showActivityIndicator(view: view)
        
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
            
        let dataLoader = DataLoader()
        dataLoader.request(.searchUsers(matching: username), of: UsersSearchResponse.self)
            .done { (searchResponse) -> Void in
                self.users = searchResponse.all

                if self.users.count == 0 {
                    self.showEmptyView(over: self.view, with: self.username)
                } else {
                    snapshot.appendItems(self.users, toSection: .main)
                    self.dataSource.apply(snapshot, animatingDifferences: true)
                }
            }.catch { (error) in
                self.showEmptyView(over: self.view, with: "No results")
                self.showErrorMessageAlert(error.localizedDescription)
            }.finally {
                self.hideActivityIndicator()
            }
    }
}

//MARK: UICollectionViewDelegate methods
extension SearchResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = dataSource.itemIdentifier(for: indexPath) else { return }
        coordinator?.showUserDetails(for: user)
    }
}
