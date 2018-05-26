//
//  PurchaseProtocols.swift
//  vimojo
//
//  Created Alejandro Arjonilla Garcia on 15/12/17.
//  Copyright © 2017 Videona. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

import StoreKit

enum ProductResponse {
    case error
    case success(products: [SKProduct])
}
//MARK: Wireframe -
protocol PurchaseWireframeProtocol: class {
    
}
//MARK: Presenter -
protocol PurchasePresenterProtocol: class {
    func loadProducts()
    func restoreProducts()
}

//MARK: Interactor -
protocol PurchaseInteractorProtocol: class {
    
    var presenter: PurchasePresenterProtocol?  { get set }
    func loadProducts(response: @escaping (ProductResponse) -> Void)
    func buyProduct(product: SKProduct)
    func restoreProduct()
}

//MARK: View -
protocol PurchaseViewProtocol: class {
    
    var presenter: PurchasePresenterProtocol?  { get set }
    var products: [ProductViewModel] { get set }
    func showError(with title: String, description: String)
}
