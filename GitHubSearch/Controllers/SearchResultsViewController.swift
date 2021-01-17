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
    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureCollectionView()
        configureDataSource()
        showActivityIndicator()
    }
    
    func configureCollectionView() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = "Search results for: \(username ?? "")"
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .white
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    func showActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSIze = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSIze, subitem: item, count: 3)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

//MARK: Diffable datasource configuration
extension SearchResultsViewController {
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UserCollectionViewCell, User> { cell, _, user in
            let content = UserCellContentConfiguration(userLogin: user.login)
            cell.contentConfiguration = content
        }
        
        dataSource = CollectionDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: user)
        })
        
        self.initialSnapshot()
    }
    
    private func initialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        
        let dataLoader = DataLoader()
        dataLoader.request(.searchUsers(matching: username)) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()

                    let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(ac, animated: true)
                    
                    self?.showEmptyResultsView()
                }
            case .success(let users):
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()

                    if users.count == 0 {
                        self?.showEmptyResultsView()
                    } else {
                        snapshot.appendItems(users)
                        self?.dataSource.apply(snapshot, animatingDifferences: true)
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
