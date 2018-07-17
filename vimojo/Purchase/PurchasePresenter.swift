//
//  PurchasePresenter.swift
//  vimojo
//
//  Created Alejandro Arjonilla Garcia on 15/12/17.
//  Copyright © 2017 Videona. All rights reserved.
//


import UIKit
import StoreKit

typealias BoolAction = (Bool) -> Void
struct ProductViewModel {
    let title: String?
    let subtitle: String?
    let buttonText: String?
    let isPurchased: Bool
    let buyAction: BoolAction
    
    init(with product: SKProduct,
         action: @escaping BoolAction) {
        self.title = product.localizedTitle
        self.subtitle = product.localizedDescription
		 let purchaseProduct = PurchaseProduct(rawValue: product.productIdentifier)
        self.isPurchased = purchaseProduct != nil ? PurchaseProduct.isProductPurchased(product: purchaseProduct!): false
        self.buyAction = action
        let unpurchasedText = "\("action_accept_purchase".localized(.purchase)) \(product.price)\(String(describing: product.priceLocale.currencySymbol!))"
        self.buttonText = isPurchased ? "product_purchased".localized(.purchase) : unpurchasedText
    }
}
class PurchasePresenter: PurchasePresenterProtocol {

    weak private var view: PurchaseViewProtocol?
    var interactor: PurchaseInteractorProtocol?
    private let router: PurchaseWireframeProtocol

    init(interface: PurchaseViewProtocol,
         interactor: PurchaseInteractorProtocol?,
         router: PurchaseWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
        NotificationCenter.default.addObserver(self, selector: #selector(purchasedProduct),
                                               name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                               object: nil)
    }
    func loadProducts() {
        interactor?.loadProducts(response: { (response) in
            switch response {
            case .error: print("Error")
            case .success(let products):
                self.view?.products = products.map({ product in
                    ProductViewModel(with: product, action: { wasBought in
                        if wasBought { print("Already bought this product \(product.localizedDescription)")}        
                        else { self.interactor?.buyProduct(product: product) }
                }) })
            }
        })
    }
    func restoreProducts() {
        interactor?.restoreProduct()
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            self.loadProducts()
        }
    }
    @objc func purchasedProduct() {
        loadProducts()
    }
}
