//
//  ChocolateCell.swift
//  RxChocolate
//
//  Created by Maxim Zheleznyy on 3/16/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class ChocolateCell: UITableViewCell {
    static let Identifier = "ChocolateCell"
  
    @IBOutlet private var countryNameLabel: UILabel!
    @IBOutlet private var emojiLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
  
    func configureWithChocolate(chocolate: Chocolate) {
        countryNameLabel.text = chocolate.countryName
        emojiLabel.text = "🍫" + chocolate.countryFlagEmoji
        priceLabel.text = CurrencyFormatter.dollarsFormatter.string(from: chocolate.priceInDollars)
        
    }
}
