//
//  HomeViewController.swift
//  CoordinatorSample
//
//  Created by Domin Kim on 2021/07/08.
//

import UIKit

class HomeViewController: BaseViewController {
    
    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.frame = CGRect(x: 200, y: 400, width: 50, height: 50)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.button)
        
        self.button.addTarget(self, action: #selector(self.tap), for: .touchUpInside)
    }
    
    @objc func tap() {
        (self.coordinator as? HomeCoordinator)?.navigateToDetail()
    }
}
