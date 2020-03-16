//
//    ChocolatesListViewController.swift
//    RxChocolate
//
//    Created by Maxim Zheleznyy on 3/16/20.
//    Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class ChocolatesListViewController: UIViewController {
    @IBOutlet weak var cartButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let europeanChocolates = Chocolate.ofEurope
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chocolate!!!"
        
        tableView.dataSource = self
        tableView.delegate = self
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCartButton()
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
        ShoppingCart.sharedCart.chocolates.append(chocolate)
        updateCartButton()
    }
}

//MARK: - Imperative methods
extension ChocolatesListViewController {
    func updateCartButton() {
        cartButton.title = "\(ShoppingCart.sharedCart.chocolates.count) 🍫"
    }
}

// MARK: - SegueHandler
extension ChocolatesListViewController: SegueHandler {
    enum SegueIdentifier: String {
        case goToCart
    }
}
