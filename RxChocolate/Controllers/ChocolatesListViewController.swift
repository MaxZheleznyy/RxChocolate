//
//    ChocolatesListViewController.swift
//    RxChocolate
//
//    Created by Maxim Zheleznyy on 3/16/20.
//    Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit
import RxSwift

class ChocolatesListViewController: UIViewController {
    @IBOutlet weak var cartButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let europeanChocolates = Chocolate.ofEurope
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chocolate!!!"
        
        setupCartObserver()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - Table view data source
extension ChocolatesListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return europeanChocolates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChocolateCell.Identifier, for: indexPath) as? ChocolateCell else { return UITableViewCell() }
        
        let chocolate = europeanChocolates[indexPath.row]
        cell.configureWithChocolate(chocolate: chocolate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let chocolate = europeanChocolates[indexPath.row]
        let freshValue = ShoppingCart.sharedCart.chocolates.value + [chocolate]
        ShoppingCart.sharedCart.chocolates.accept(freshValue)
    }
}

// MARK: - Rx configuration
extension ChocolatesListViewController {
    func setupCartObserver() {
      ShoppingCart.sharedCart.chocolates.asObservable().subscribe(onNext: { [unowned self] chocolates in
          self.cartButton.title = "\(chocolates.count) 🍫"
        })
        .disposed(by: disposeBag)
    }
}

// MARK: - SegueHandler
extension ChocolatesListViewController: SegueHandler {
    enum SegueIdentifier: String {
        case goToCart
    }
}
