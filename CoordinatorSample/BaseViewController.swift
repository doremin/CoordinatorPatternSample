//
//  ViewController.swift
//  CoordinatorSample
//
//  Created by Domin Kim on 2021/07/08.
//

import UIKit

class BaseViewController: UIViewController {
    
    var coordinator: Coordinator? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
    }

}

