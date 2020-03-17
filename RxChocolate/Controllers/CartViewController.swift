//
//    CartViewController.swift
//    RxChocolate
//
//    Created by Maxim Zheleznyy on 3/16/20.
//    Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {
    @IBOutlet weak var checkoutButton: ChocolateButton!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cart"
        configureFromCart()
    }
    
    @IBAction func resetAction(_ sender: UIButton) {
        ShoppingCart.sharedCart.chocolates.accept([])
        let _ = navigationController?.popViewController(animated: true)
    }
}

//MARK: - Configuration methods
extension CartViewController {
    func configureFromCart() {
        guard checkoutButton != nil else { return }
        
        let cart = ShoppingCart.sharedCart
        totalItemsLabel.text = cart.itemCountString
        
        let cost = cart.totalCost
        totalCostLabel.text = CurrencyFormatter.dollarsFormatter.string(from: cost)
        
        checkoutButton.isEnabled = (cost > 0)
    }
}
