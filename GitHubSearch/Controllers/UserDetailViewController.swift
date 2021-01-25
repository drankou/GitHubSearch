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
    
    var dataSource: CollectionDataSource! = nil
    
    var user: User!
    weak var coordinator: MainCoordinator?
    
    var repositories = [Repository]()
    var listItems = [
        ListItem(image: SFSymbols.book, name: "Repositories", count: 0),
        ListItem(image: SFSymbols.star, name: "Starred", count: 0),
        ListItem(image: SFSymbols.company, name: "Organizations", count: 0),
    ]
    
    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dummyData()
        
        fetchUserDetails()
        configureHierarchy()
        configureDataSource()
    }
    
    
    var mainStack = UIStackView()
    var userDetailView: UserDetailView!
    var collectionView: UICollectionView!
    
    private func configureHierarchy() {
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        let containerView = UIView()
        scrollView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        containerView.addSubview(mainStack)
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
            mainStack.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
            mainStack.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor),
            mainStack.widthAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.widthAnchor)
        ])
        
        configureUserDetailView()
        configureCollectionView()
    }
    
    private func configureUserDetailView() {
        userDetailView = UserDetailView()
        userDetailView.isHidden = true
        mainStack.addArrangedSubview(userDetailView)
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createPerSectionLayout())
        mainStack.addArrangedSubview(collectionView)
        collectionView.isHidden = true
        collectionView.backgroundColor = .white
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 350)
        ])
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
    }
    
    private func fetchUserDetails() {
        showActivityIndicator(view: view)
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
                    self.userDetailView.user = user
                    self.hideActivityIndicator()
                    self.userDetailView.isHidden = false
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
        
        return layout
    }
    
    func generateRepositoriesLayoutSection() -> NSCollectionLayoutSection {
        let estimatedHeight = CGFloat(150) //estimated height has to be set to both item and group size for automatic dynamic cell sizing (based on content)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .fractionalWidth(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    func generateOverviewListLayoutSection() -> NSCollectionLayoutSection {
        #warning("Set up custom list item layout")
//        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
//        let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: layoutEnvironment)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
    
        return section
    }
    
    func configureDataSource() {
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

        initialSnapshot()
    }
    
    func initialSnapshot(){
        var snapshot = Snapshot()
        snapshot.appendSections([.repositories])
        self.repositories.forEach { snapshot.appendItems([Item.repository($0)]) }
        
        snapshot.appendSections([.overviewList])
        self.listItems.forEach { snapshot.appendItems([Item.listItem($0)]) }
        
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
