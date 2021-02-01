//
//  ListViewController.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 31.01.2021.
//

import UIKit
import PromiseKit

class ListViewController: UIViewController {
    enum Section {
        case main
    }
    
    enum Item: Hashable {
        case repository(Repository)
        case organization(Organization)
    }
    
    typealias TableViewDatasource = UITableViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    weak var coordinator: MainCoordinator?
    var tableView: UITableView!
    var datasource: TableViewDatasource!
    
    var user: User!
    var listType: ListItem.Category!
    var repos: [Repository]?
    var organizations: [Organization]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = listType.rawValue
        configureTableView()
        configureDatasource()
        
        fetchData()
    }
     
    func fetchData(){
        self.showActivityIndicator(view: view)
        let dataLoader = DataLoader()
    
        switch listType {
        case .repositories:
            fetchRepositories(promise: dataLoader.getRepos(for: user.login))
        case .starred:
            fetchRepositories(promise: dataLoader.getStarred(for: user.login))
        case .organizations:
            fetchOrganizations(promise: dataLoader.getOrganizations(for: user.login))
        case .none:
            return
        }
    }
    
    func fetchRepositories(promise: Promise<[Repository]>) {
        promise.done { (repos) in
            if repos.isEmpty {
                self.showEmptyView(over: self.view, with: "There are no repositories :(")
            } else {
                self.repos = repos
                self.initialSnapshot()
            }
        }.catch { error in
            self.showErrorMessageAlert(error.localizedDescription)
        }.finally {
            self.hideActivityIndicator()
        }
    }
    
    func fetchOrganizations(promise: Promise<[Organization]>){
        promise.done { (orgs) in
            if orgs.isEmpty {
                self.showEmptyView(over: self.view, with: "No organizations :(")
            } else {
                self.organizations = orgs
                self.initialSnapshot()
            }
        }.catch { error in
            self.showErrorMessageAlert(error.localizedDescription)
        }.finally {
            self.hideActivityIndicator()
        }
    }
}

//MARK: UITableView configuration
extension ListViewController {
    func configureTableView(){
        tableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .systemBackground
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "itemCell")
    }
    
    func configureDatasource() {
        datasource = TableViewDatasource(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") else { return nil }
            
            switch item{
            case .repository(let repo):
                cell.textLabel?.text = repo.name
            case .organization(let org):
                cell.textLabel?.text = org.login
            }
            
            return cell
        })
    }
    
    func initialSnapshot(){
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        
        switch listType {
        case .repositories, .starred:
            if let repos = self.repos {
                snapshot.appendItems(repos.map { Item.repository($0) })
            }
        case .organizations:
            if let orgs = self.organizations {
                snapshot.appendItems(orgs.map { Item.organization($0) })
            }
        default:
            return
        }
        
        datasource.apply(snapshot, animatingDifferences: false)
    }
}
