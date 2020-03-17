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
    
    let europeanChocolates = Observable.just(Chocolate.ofEurope)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chocolate!!!"
        
        setupCartObserver()
        setupCellConfiguration()
        setupCellTapHandling()
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
    
    func setupCellConfiguration() {
      europeanChocolates.bind(to: tableView.rx.items(
        cellIdentifier: ChocolateCell.Identifier, cellType: ChocolateCell.self)) { row, chocolate, cell in
            cell.configureWithChocolate(chocolate: chocolate)
        }
        .disposed(by: disposeBag)
    }
    
    func setupCellTapHandling() {
        tableView.rx.modelSelected(Chocolate.self).subscribe(onNext: { [unowned self] chocolate in
          let newValue =  ShoppingCart.sharedCart.chocolates.value + [chocolate]
          ShoppingCart.sharedCart.chocolates.accept(newValue)
            
          if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
          }
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
