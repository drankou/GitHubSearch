//
//  UserDetailViewController.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 14.01.2021.
//

import UIKit

struct ListItem: Hashable {
    var image: UIImage
    var name: String
    var count: Int
}

class UserDetailViewController: UIViewController {
    //MARK: Types
    struct ElementKind {
        static let layoutHeader = "layout-header-element-kind"
        static let repositoriesSectionHeader = "repositories-section-header-element-kind"
    }
    
    enum Section: Int, CaseIterable {
        case repositories
        case overviewList
    }
    
    enum Item: Hashable {
        case repository(Repository)
        case listItem(ListItem)
    }
    
    typealias CollectionDataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    //MARK: Properties
    weak var coordinator: MainCoordinator?
    var dataSource: CollectionDataSource! = nil
    var collectionView: UICollectionView!
    var user: User!
    
    var repositories = [
        Repository(id: 0, name: "go-vader", fullName: "", fork: false, description: "Sentiment Analysis tool using VADER in GO", url: "", language: "Go", stargazersCount: 2, watchersCount: 0),
        Repository(id: 1, name: "IMS", fullName: "", fork: false, description: "", url: "", language: "C++", stargazersCount: 0, watchersCount: 0),
        Repository(id: 2, name: "go-freeling", fullName: "", fork: false, description: "Golang Natural Language", url: "", language: "Go", stargazersCount: 2, watchersCount: 0)
    ]
    
    var listItems = [
        ListItem(image: SFSymbols.book, name: "Repositories", count: 0),
        ListItem(image: SFSymbols.star, name: "Starred", count: 0),
        ListItem(image: SFSymbols.company, name: "Organizations", count: 0),
    ]
    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .action)
        configureCollectionView()
        
        fetchUserDetails()
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createPerSectionLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.isHidden = true
        
        collectionView.register(HeaderSupplementaryView.self, forSupplementaryViewOfKind: ElementKind.layoutHeader, withReuseIdentifier: HeaderSupplementaryView.reuseIdentifier)
        collectionView.register(RepositoriesSectionTitleView.self, forSupplementaryViewOfKind: ElementKind.repositoriesSectionHeader, withReuseIdentifier: RepositoriesSectionTitleView.reuseIdentifier)
    }
    
    private func fetchUserDetails() {
        showActivityIndicator(view: self.view)
        let dataLoader = DataLoader()
        dataLoader.request(.userInfo(for: user.login), of: User.self) { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.showErrorMessageAlert(error.localizedDescription)
                }
            case .success(let user):
                //copy existing image to new user instance
                if self.user.avatarImage != ImageCache.publicCache.placeholderImage {
                    user.avatarImage = self.user.avatarImage
                }
                self.user = user
                
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                                            
                    //hotfix
                    // -- this way doesnt mess up scrolling area of repositories seciton, but if conifguration is done in viewDidLoad, than it's problematic
                    self.configureDataSource()
                    // --
                    
                    self.collectionView.isHidden = false
                }
            }
        }
    }
}


//MARK: UICollectionViewCompositionalLayout configuration
extension UserDetailViewController {
    func createPerSectionLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
                        
            switch section {
            case .repositories:
                return self.generateRepositoriesLayoutSection()
            case .overviewList:
                return self.generateOverviewListLayoutSection()
            }
        }
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(500))
        let layoutHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: ElementKind.layoutHeader, alignment: .top)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 15
        config.boundarySupplementaryItems = [layoutHeader]
        layout.configuration = config

        return layout
    }
    
    func generateRepositoriesLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .groupPaging
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: ElementKind.repositoriesSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func generateOverviewListLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15)
    
        return section
    }
        
    func configureDataSource() {
        let layoutHeadersupplementaryRegistration = UICollectionView.SupplementaryRegistration<HeaderSupplementaryView>(elementKind: ElementKind.layoutHeader) { (headerView, kind, indexPath) in
            //TODO refactor
            headerView.user = self.user
        }
        
        let repositoryCellRegistration = UICollectionView.CellRegistration<RepositoryCell, Repository> { (cell, indexPath, repository) in
            var content = cell.defaultContentConfiguration()
            
            content.userImage = self.user.avatarImage
            content.userLogin = self.user.login
            content.repositoryName = repository.name
            content.repositoryDescription = repository.description
            content.repositoryLanguage = repository.language
            content.stargazersCount = repository.stargazersCount
            
            cell.contentConfiguration = content
        }
        
        let listCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ListItem> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            
            content.image = item.image
            content.text = item.name

            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            
            switch item {
            case.repository(let repository):
                return collectionView.dequeueConfiguredReusableCell(using: repositoryCellRegistration, for: indexPath, item: repository)
            case .listItem(let listItem):
                return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: listItem)
            }
        }
        
        dataSource.supplementaryViewProvider = {(collectionView, kind, indexPath) -> UICollectionReusableView? in
            switch kind {
            case ElementKind.layoutHeader:
                return collectionView.dequeueConfiguredReusableSupplementary(using: layoutHeadersupplementaryRegistration, for: indexPath)
            case ElementKind.repositoriesSectionHeader:
                return collectionView.dequeueReusableSupplementaryView(ofKind: ElementKind.repositoriesSectionHeader, withReuseIdentifier: RepositoriesSectionTitleView.reuseIdentifier, for: indexPath)
            default:
                fatalError("Failed to get expected supplementary reusable view from collection view. Stopping the program execution")
            }
        }
                
        initialSnapshot()
    }
    
    func initialSnapshot(){
        var snapshot = Snapshot()
        snapshot.appendSections([.repositories, .overviewList])
        snapshot.appendItems(repositories.map { Item.repository($0) }, toSection: .repositories)
        snapshot.appendItems(listItems.map { Item.listItem($0) }, toSection: .overviewList)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func dummyData() {
        self.repositories = [
            Repository(id: 0, name: "go-vader", fullName: "", owner: user, fork: false, description: "Sentiment Analysis tool using VADER in GO", url: "", language: "Go", stargazersCount: 2, watchersCount: 0),
            Repository(id: 1, name: "IMS", fullName: "", owner: user, fork: false, description: "", url: "", language: "C++", stargazersCount: 0, watchersCount: 0),
            Repository(id: 2, name: "go-freeling", fullName: "", owner: user, fork: false, description: "Golang Natural Language", url: "", language: "Go", stargazersCount: 2, watchersCount: 0),
            Repository(id: 3, name: "coinmarketcap-go", fullName: "", owner: user, fork: false, description: "API wrapper for Coinmarketcap implemented in GoLang", url: "", language: "Go", stargazersCount: 0, watchersCount: 0),
            Repository(id: 4, name: "iza-proj2", fullName: "", owner: user, fork: false, description: "", url: "", language: "Go", stargazersCount: 0, watchersCount: 0)
        ]
    }
}

extension UserDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch item {
        case .listItem(let listItem):
            print("\(listItem.name)")
        case .repository(let repository):
            print("\(repository.name)")
        }
    }
}
