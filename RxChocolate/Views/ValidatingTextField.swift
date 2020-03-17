//
//  ValidatingTextField.swift
//  RxChocolate
//
//  Created by Maxim Zheleznyy on 3/16/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

class ValidatingTextField: UITextField {
    var valid: Bool = false {
        didSet {
            configureForValid()
        }
    }
    
    var hasBeenExited: Bool = false {
        didSet {
            configureForValid()
        }
    }
  
  override func resignFirstResponder() -> Bool {
    hasBeenExited = true
    return super.resignFirstResponder()
  }
  
  private func configureForValid() {
    if !valid && hasBeenExited {
      backgroundColor = .red
    } else {
      backgroundColor = .clear
    }
  }
}
