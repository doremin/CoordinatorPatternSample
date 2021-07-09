//
//  HomeViewController.swift
//  CoordinatorSample
//
//  Created by Domin Kim on 2021/07/08.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class HomeViewController: BaseViewController {
    
    // MARK: UI
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tt")
        return tableView
    }()
    
    // MARK: View Model
    let viewModel: HomeViewModel
    
    // MARK: Initializer
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Layout
    override func makeConstraints() {
        super.makeConstraints()
        
        self.title = "Home"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add)

        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
    }
    
    // MARK: Binding
    override func bind() {
        super.bind()
        
        // MARK: From View Model
        self.viewModel.todos
            .bind(to: self.tableView.rx.items(cellIdentifier: "tt")) { index, todo, cell in
                cell.textLabel?.text = todo.title
            }
            .disposed(by: self.disposeBag)
        
        // MARK: To View Model
        self.navigationItem.rightBarButtonItem?.rx.tap
            .bind(onNext: self.viewModel.navigateToDetail)
            .disposed(by: self.disposeBag)
    }
}
