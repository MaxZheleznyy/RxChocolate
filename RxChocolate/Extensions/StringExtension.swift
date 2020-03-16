//
//  StringForCreditCard.swift
//  RxChocolate
//
//  Created by Maxim Zheleznyy on 3/16/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation

extension String {
    
    var areAllCharactersNumbers: Bool {
        let nonNumberCharacterSet = CharacterSet.decimalDigits.inverted
        return (rangeOfCharacter(from: nonNumberCharacterSet) == nil)
    }
    
    var isLuhnValid: Bool {
      //why we need Luhn algorithm reference - https://www.rosettacode.org/wiki/Luhn_test_of_credit_card_numbers
      
      guard areAllCharactersNumbers else { return false }
      
      let reversed = self.reversed().map { String($0) }
      
      var sum = 0
      for (index, element) in reversed.enumerated() {
        //just a double check
        guard let digit = Int(element) else { return false }
        
        if index % 2 == 1 {
          switch digit {
          case 9:
            //Just add nine.
            sum += 9
          default:
            //Multiply by 2, then take the remainder when divided by 9 to get addition of digits.
            sum += ((digit * 2) % 9)
          }
        } else {
          sum += digit
        }
      }
      
      //Valid if divisible by 10
      return sum % 10 == 0
    }
    
    var removingSpaces: String {
      return replacingOccurrences(of: " ", with: "")
    }
    
    var addingSlash: String {
        guard count > 2 else { return self }
    
        let index2 = index(startIndex, offsetBy: 2)
        let firstTwo = prefix(upTo: index2)
        let rest = suffix(from: index2)
        
        return firstTwo + " / " + rest
    }
    
    var removingSlash: String {
        return removingSpaces.replacingOccurrences(of: "/", with: "")
    }
      
    var isExpirationDateValid: Bool {
        let noSlash = removingSlash
        
        guard noSlash.count == 6 //Must be mmyyyy
          && noSlash.areAllCharactersNumbers else { //must be all numbers
            return false
        }
        
        let index2 = index(startIndex, offsetBy: 2)
        let monthString = prefix(upTo: index2)
        let yearString = suffix(from: index2)
        
        guard let month = Int(monthString),
          let year = Int(yearString) else {
            //We can't even check.
            return false
        }
        
        //Month must be between january and december.
        guard (month >= 1 && month <= 12) else {
          return false
        }
        
        let now = Date()
        let currentYear = now.year
        
        guard year >= currentYear else {
          //Year is before current: Not valid.
          return false
        }
        
        if year == currentYear {
          let currentMonth = now.month
          guard month >= currentMonth else {
            //Month is before current in current year: Not valid.
            return false
          }
        }
        
        //success
        return true
    }
    
    func integerValue(ofFirstCharacters count: Int) -> Int? {
      guard areAllCharactersNumbers, count <= self.count else { return nil }
      
      let substring = prefix(count)
      guard let integerValue = Int(substring) else { return nil }
      
      return integerValue
    }
}
