//
//  AddViewController.swift
//  CoordinatorSample
//
//  Created by Domin Kim on 2021/07/08.
//

import UIKit

class AddViewController: BaseViewController {
    
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
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()
    
    let viewModel: AddViewModel
    
    init(viewModel: AddViewModel) {
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
        
        self.view.addSubview(self.titleField)
        self.view.addSubview(self.contentTextView)
        self.view.addSubview(self.addButton)
        
        self.titleField.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(30)
        }
        
        self.contentTextView.snp.makeConstraints { make in
            make.left.right.equalTo(self.titleField)
            make.top.equalTo(self.titleField.snp.bottom).offset(15)
            make.bottom.equalTo(self.addButton.snp.top).offset(-15)
        }
        
        self.addButton.snp.makeConstraints { make in
            make.left.right.equalTo(self.titleField)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(50)
        }
    }
    
    override func bind() {
        super.bind()
        
        self.contentTextView.rx.
        
        let input = AddViewModel.Input(
            title: self.titleField.rx.text.asObservable(),
            contents: self.contentTextView.rx.text.asObservable(),
            addButtonTap: addButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel.transform(input: input)

        output.addResult
            .subscribe(
                onNext: { [unowned self] result in
                    switch result {
                    case .success:
                        self.viewModel.navigateToHome()
                    case .failure(let error):
                        let alert = UIAlertController(
                            title: "Error",
                            message: error.localizedDescription,
                            preferredStyle: .alert
                        )
                        alert.addAction(
                            UIAlertAction(title: "OK", style: .default)
                        )
                        self.present(alert, animated: true)
                    }
                }
            )
            .disposed(by: self.disposeBag)
    }
}
