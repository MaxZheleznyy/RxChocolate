//
//    BillingInfoViewController.swift
//    RxChocolate
//
//    Created by Maxim Zheleznyy on 3/16/20.
//    Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BillingInfoViewController: UIViewController {
    @IBOutlet weak var creditCardNumberTextField: ValidatingTextField!
    @IBOutlet weak var creditCardImageView: UIImageView!
    @IBOutlet weak var expirationDateTextField: ValidatingTextField!
    @IBOutlet weak var cvvTextField: ValidatingTextField!
    @IBOutlet weak var purchaseButton: ChocolateButton!
    
    private let cardType: BehaviorRelay<CardType> = BehaviorRelay(value: .unknown)
    private let throttleIntervalInMilliseconds = 100
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "💳 Info"
        setupCardImageDisplay()
        setupTextChangeHandling()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = self.identifier(forSegue: segue)
        switch identifier {
        case .purchaseSuccess:
            guard let destination = segue.destination as? ChocolateIsComingViewController else {
                assertionFailure("Couldn't get chocolate is coming VC!")
                return
            }
            
            destination.cardType = cardType.value
        }
    }
}

// MARK: - Rx configuration
extension BillingInfoViewController {
    func setupCardImageDisplay() {
        cardType.asObservable().subscribe(onNext: { [unowned self] cardType in
          self.creditCardImageView.image = cardType.image
        })
        .disposed(by: disposeBag)
    }
    
    func setupTextChangeHandling() {
        //credit card
        let creditCardValid = creditCardNumberTextField.rx.text.observeOn(MainScheduler.asyncInstance).distinctUntilChanged()
            .throttle(.milliseconds(throttleIntervalInMilliseconds), scheduler: MainScheduler.instance).map { [unowned self] in
                self.validate(cardText: $0)
        }
        
        creditCardValid.subscribe(onNext: { [unowned self] in
            self.creditCardNumberTextField.valid = $0
        })
        .disposed(by: disposeBag)
        
        //expiration date
        let expirationValid = expirationDateTextField.rx.text.observeOn(MainScheduler.asyncInstance).distinctUntilChanged()
          .throttle(.milliseconds(throttleIntervalInMilliseconds), scheduler: MainScheduler.instance).map { [unowned self] in
            self.validate(expirationDateText: $0)
        }
            
        expirationValid.subscribe(onNext: { [unowned self] in
            self.expirationDateTextField.valid = $0
          })
          .disposed(by: disposeBag)
            
        //cvv code
        let cvvValid = cvvTextField.rx.text.observeOn(MainScheduler.asyncInstance).distinctUntilChanged().map { [unowned self] in
            self.validate(cvvText: $0)
        }
            
        cvvValid.subscribe(onNext: { [unowned self] in
            self.cvvTextField.valid = $0
        })
        .disposed(by: disposeBag)
        
        //finishing touch
        let everythingValid = Observable.combineLatest(creditCardValid, expirationValid, cvvValid) {
            $0 && $1 && $2
        }
            
        everythingValid.bind(to: purchaseButton.rx.isEnabled)
        .disposed(by: disposeBag)
    }
}

//MARK: - Validation methods
private extension BillingInfoViewController {
    func validate(cardText: String?) -> Bool {
        guard let cardText = cardText else { return false }
        let noWhitespace = cardText.removingSpaces
        
        updateCardType(using: noWhitespace)
        formatCardNumber(using: noWhitespace)
        advanceIfNecessary(noSpacesCardNumber: noWhitespace)
        
        guard cardType.value != .unknown else { return false }
        guard noWhitespace.isLuhnValid else { return false }
        
        return noWhitespace.count == cardType.value.expectedDigits
    }
    
    func validate(expirationDateText expiration: String?) -> Bool {
        guard let expiration = expiration else { return false }
        let strippedSlashExpiration = expiration.removingSlash
        
        formatExpirationDate(using: strippedSlashExpiration)
        advanceIfNecessary(expirationNoSpacesOrSlash: strippedSlashExpiration)
        
        return strippedSlashExpiration.isExpirationDateValid
    }
    
    func validate(cvvText cvv: String?) -> Bool {
        guard let cvv = cvv else { return false }
        guard cvv.areAllCharactersNumbers else { return false }
        
        dismissIfNecessary(cvv: cvv)
        
        return cvv.count == cardType.value.cvvDigits
    }
}

//MARK: Single-serve helper functions
private extension BillingInfoViewController {
    func updateCardType(using noSpacesNumber: String) {
        cardType.accept(CardType.fromString(string: noSpacesNumber))
    }
    
    func formatCardNumber(using noSpacesCardNumber: String) {
        creditCardNumberTextField.text = cardType.value.format(noSpaces: noSpacesCardNumber)
    }
    
    func advanceIfNecessary(noSpacesCardNumber: String) {
        if noSpacesCardNumber.count == cardType.value.expectedDigits {
            expirationDateTextField.becomeFirstResponder()
        }
    }
    
    func formatExpirationDate(using expirationNoSpacesOrSlash: String) {
        expirationDateTextField.text = expirationNoSpacesOrSlash.addingSlash
    }
    
    func advanceIfNecessary(expirationNoSpacesOrSlash: String) {
        if expirationNoSpacesOrSlash.count == 6 {
            cvvTextField.becomeFirstResponder()
        }
    }
    
    func dismissIfNecessary(cvv: String) {
        if cvv.count == cardType.value.cvvDigits {
            let _ = cvvTextField.resignFirstResponder()
        }
    }
}

// MARK: - SegueHandler
extension BillingInfoViewController: SegueHandler {
    enum SegueIdentifier: String {
        case purchaseSuccess
    }
}

