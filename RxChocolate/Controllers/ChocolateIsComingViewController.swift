//
//    ChocolateIsComingViewController.swift
//    RxChocolate
//
//    Created by Maxim Zheleznyy on 3/16/20.
//    Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class ChocolateIsComingViewController: UIViewController {
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var creditCardIcon: UIImageView!
    
    
    var cardType: CardType = .unknown {
        didSet {
            configureIconForCardType()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureIconForCardType()
        configureLabelsFromCart()
    }
}

//MARK: - Configuration methods
private extension ChocolateIsComingViewController {
    func configureIconForCardType() {
        guard let imageView = creditCardIcon else { return }
        
        imageView.image = cardType.image
    }
    
    func configureLabelsFromCart() {
        guard let costLabel = costLabel else { return }
        
        let cart = ShoppingCart.sharedCart
        
        costLabel.text = CurrencyFormatter.dollarsFormatter.string(from: cart.totalCost)
        
        orderLabel.text = cart.itemCountString
    }
}
