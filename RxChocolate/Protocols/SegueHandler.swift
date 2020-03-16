//
//  SegueHandler.swift
//  RxChocolate
//
//  Created by Maxim Zheleznyy on 3/16/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

 //reference material - https://www.natashatherobot.com/protocol-oriented-segue-identifiers-swift/

protocol SegueHandler {
  associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandler
    where Self: UIViewController, SegueIdentifier.RawValue == String {
    func performSegue(withIdentifier identifier: SegueIdentifier, sender: AnyObject? = nil) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
    func identifier(forSegue segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let stringIdentifier = segue.identifier, let identifier = SegueIdentifier(rawValue: stringIdentifier) else {
            fatalError("Couldn't find identifier for segue!")
        }
        
        return identifier
    }
}
