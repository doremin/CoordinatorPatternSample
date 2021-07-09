//
//  DetailViewController.swift
//  CoordinatorSample
//
//  Created by Domin Kim on 2021/07/08.
//

import UIKit

class DetailViewController: BaseViewController {
    
    private let titleField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .default
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.black.cgColor
        textField.clipsToBounds = true
        return textField
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 0.5
        textView.clipsToBounds = true
        return textView
    }()
    
    let viewModel: DetailViewModel
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        self.title = "Detail"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add)
        self.view.addSubview(self.titleField)
        self.view.addSubview(self.contentTextView)
        
        self.titleField.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(30)
        }
        
        self.contentTextView.snp.makeConstraints { make in
            make.left.right.equalTo(self.titleField)
            make.top.equalTo(self.titleField.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    override func bind() {
        super.bind()
        
        self.titleField.rx.text
            .orEmpty
            .bind(to: self.viewModel.title)
            .disposed(by: self.disposeBag)
        
        self.contentTextView.rx.text
            .orEmpty
            .subscribe(onNext: { print($0) })
//            .bind(to: self.viewModel.contents)
            .disposed(by: self.disposeBag)
        
        self.navigationItem.rightBarButtonItem?.rx.tap
            .bind(onNext: self.viewModel.addTodo)
            .disposed(by: self.disposeBag)
    }
}
