//
//  PurchasePresenter.swift
//  vimojo
//
//  Created Alejandro Arjonilla Garcia on 15/12/17.
//  Copyright © 2017 Videona. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import StoreKit

typealias BoolAction = (Bool) -> Void
struct ProductViewModel {
    let title: String?
    let subtitle: String?
    let buttonText: String?
    let buyAction: BoolAction
    
    private var wasBought: (String) -> Bool {
        return { key in
            return UserDefaults.standard.bool(forKey: key)
        }
    }
    init(with product: SKProduct, action: @escaping BoolAction) {
        self.title = product.localizedTitle
        self.subtitle = product.localizedDescription
        self.buttonText =
        "Compra ahora por: \(product.price)\(String(describing: product.priceLocale.currencySymbol)))"
        self.buyAction = action
    }
}
class PurchasePresenter: PurchasePresenterProtocol {

    weak private var view: PurchaseViewProtocol?
    var interactor: PurchaseInteractorProtocol?
    private let router: PurchaseWireframeProtocol

    init(interface: PurchaseViewProtocol, interactor: PurchaseInteractorProtocol?, router: PurchaseWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    func loadProducts() {
        interactor?.loadProducts(response: { (response) in
            switch response {
            case .error(let error): print("Error")
            case .success(let products):
                self.view?.products = products.map({ product in
                    ProductViewModel(with: product, action: { wasBought in
                        if wasBought { print("Already bought this product \(product.localizedDescription)")}        
                        else { self.interactor?.buyProduct(product: product) }
                }) })
            }
        })
    }
}
