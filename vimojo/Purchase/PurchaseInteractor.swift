//
//  PurchaseInteractor.swift
//  vimojo
//
//  Created Alejandro Arjonilla Garcia on 15/12/17.
//  Copyright © 2017 Videona. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import StoreKit
class PurchaseInteractor: PurchaseInteractorProtocol {
    weak var presenter: PurchasePresenterProtocol?

    func loadProducts(response: @escaping (ProductResponse) -> Void) {
        PurchaseProduct.store.requestProducts { (success, products) in
            if success, let products = products { response(.success(products: products))}
            else { response(.error) }
        }
    }
    
    func buyProduct(product: SKProduct) {
        PurchaseProduct.store.buyProduct(product)
    }
}

class PurchaseMockedInteractor: PurchaseInteractorProtocol {
    weak var presenter: PurchasePresenterProtocol?
    var error = false
    
    func loadProducts(response: @escaping (ProductResponse) -> Void) {
        return error ? response(.error):response(.success(products:
            
            [
                MockedSKProduct(),
                MockedSKProduct(),
                MockedSKProduct(),
                MockedSKProduct(),
                MockedSKProduct(),
                MockedSKProduct(),
                MockedSKProduct()
            ]))
    }
    func buyProduct(product: SKProduct) {
        
    }
}
class MockedSKProduct: SKProduct {
    override var localizedTitle: String {
        return "Mocked titlte looooooongggg tile title title"
    }
    override var localizedDescription: String {
        return """
        This is a mocked description
        of the product to fetch
        with a lot of lines
        because we are testing this shit
        """
    }
    override var price: NSDecimalNumber {
        return 1.09
    }
    override var priceLocale: Locale {
        return Locale.posix
    }
}