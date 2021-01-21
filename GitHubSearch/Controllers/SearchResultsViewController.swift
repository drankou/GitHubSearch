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
    var activityIndicator = UIActivityIndicatorView()
    
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
        collectionView.backgroundColor = .white
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    func showActivityIndicator() {
        activityIndicator.style = .medium
        activityIndicator.color = .lightGray
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func showEmptyResultsView() {
        let emptyResultsView = EmptyResultsView(query: username)
        view.addSubview(emptyResultsView)
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
            
            ImageCache.publicCache.load(url: user.avatarURL! as NSURL, item: user) { [weak self] (fetchedUser, image) in
                guard let self = self else { return }
                if let img = image, img != fetchedUser.avatarImage {
                    var updatedSnapshot = self.dataSource.snapshot()
                    if let index = updatedSnapshot.indexOfItem(user) {
                        let user = self.users[index]
                        user.avatarImage = img
                        updatedSnapshot.reloadItems([user])
                        DispatchQueue.main.async {
                            self.dataSource.apply(updatedSnapshot, animatingDifferences: true)
                        }
                    }
                }
            }
            
            cell.contentConfiguration = content
        }
        
        dataSource = CollectionDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: user)
        })
        
        self.initialSnapshot()
    }
    
    private func initialSnapshot() {
        showActivityIndicator()
        
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        
        let dataLoader = DataLoader()
        dataLoader.request(.searchUsers(matching: username), of: UserSearchResponse.self) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()

                    let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(ac, animated: true)
                    
                    self.showEmptyResultsView()
                }
            case .success(let response):
                self.users = response.items
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()

                    if self.users.count == 0 {
                        self.showEmptyResultsView()
                    } else {
                        snapshot.appendItems(self.users)
                        self.dataSource.apply(snapshot, animatingDifferences: true)
                    }
                }
            }
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
