//
//  ViewController.swift
//  CoordinatorSample
//
//  Created by Domin Kim on 2021/07/08.
//

import UIKit

import RxCocoa
import RxSwift

class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.makeConstraints()
        self.bind()
    }

    func makeConstraints() {
        
    }
    
    func bind() {
        
    }
}

