//
//  PurchaseInteractor.swift
//  vimojo
//
//  Created Alejandro Arjonilla Garcia on 15/12/17.
//  Copyright © 2017 Videona. All rights reserved.
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
    func restoreProduct() {
        PurchaseProduct.store.restorePurchases()
    }
    func buyProduct(product: SKProduct) {
        PurchaseProduct.store.buyProduct(product)
    }
}
