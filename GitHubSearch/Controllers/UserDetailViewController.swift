//
//  UserDetailViewController.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 14.01.2021.
//

import UIKit
import PromiseKit

struct ListItem: Hashable {
    enum Category: String {
        case repositories = "Repositories"
        case starred = "Starred"
        case organizations = "Organizations"
    }
    
    var image: UIImage
    var category: Category
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
  
    var repositories = [Repository]()
    var listItems = [
        ListItem(image: SFSymbols.book, category: .repositories),
        ListItem(image: SFSymbols.star, category: .starred),
        ListItem(image: SFSymbols.company, category: .organizations)
    ]
    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareProfileURL))
        configureCollectionView()

        fetchUserDetails()
    }
    
    @objc func shareProfileURL(_ sender: UIBarButtonItem) {
        let items = [URL(string: user.htmlURL)!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
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

        //TODO image caching
        firstly {
            when(fulfilled: dataLoader.getImage(user.avatarURL!), dataLoader.getUserDetail(for: user.login), dataLoader.getRepos(for: user.login), dataLoader.getStarred(for: user.login))
        }.done { (avatarImage, user, repos, starred) in
            self.user = user
            self.user.avatarImage = avatarImage ?? ImageCache.publicCache.placeholderImage
            self.repositories = repos
            self.user.starred = starred
            self.user.repos = repos
        }.catch { (error) in
            self.showErrorMessageAlert(error.localizedDescription)
        }.finally {
            //TODO refactor
            //hotfix
            // -- this way doesnt mess up scrolling area of repositories seciton; confgured in viewDidLoad causes inconsistent layout
            self.configureDataSource()
            // --

            self.hideActivityIndicator()
            self.collectionView.isHidden = false
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .groupPaging
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: ElementKind.repositoriesSectionHeader, alignment: .top, absoluteOffset: CGPoint(x: 0, y: 5))
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func generateOverviewListLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
    
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
            content.text = item.category.rawValue

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
        snapshot.appendItems(repositories.prefix(5).map { Item.repository($0) }, toSection: .repositories)
        snapshot.appendItems(listItems.map { Item.listItem($0) }, toSection: .overviewList)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension UserDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch item {
        case .listItem(let listItem):
            switch listItem.category {
            case .repositories:
                self.coordinator?.showRepositoriesList(for: user)
            case .starred:
                self.coordinator?.showRepositoriesList(for: user, starred: true)
            case .organizations:
                self.coordinator?.showOrganizationsList(for: user)
            }
            print(listItem.category.rawValue)
        case .repository(_):
            return
        }
    }
}
