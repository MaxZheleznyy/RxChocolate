//
//    ImageName.swift
//    RxChocolate
//
//    Created by Maxim Zheleznyy on 3/16/20.
//    Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit

enum ImageName: String {
    case amex, discover, mastercard, visa, unknownCard
    
    var image: UIImage? {
        guard let image = UIImage(named: rawValue) else { return nil }
        
        return image
    }
}
