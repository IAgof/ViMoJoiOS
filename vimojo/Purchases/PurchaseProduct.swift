//
//  PurchaseProduct.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 15/12/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import StoreKit

public enum PurchaseProduct: String {
    case removeWatermark = "Removewatermark"
    
    static var availableProducts: [SKProduct] = []
    
    var productIdentifier: String {
        return self.rawValue
    }
    var notification: String {
        switch self {
        case .removeWatermark: return "ProductPurchaseNotification"
        }
    }
    var dbKey: String {
        switch self {
        case .removeWatermark: return "\(self.productIdentifier)Key"
        }
    }
    private static var all: Set<PurchaseProduct> {
        return [.removeWatermark]
    }
    
    public static let store = IAPHelper(products: PurchaseProduct.all)
    
    public static func isProductPurchased(product: PurchaseProduct) -> Bool {
        return UserDefaults.standard.bool(forKey: product.dbKey)
    }
    public static func reloadProducts() {
        PurchaseProduct.store.requestProducts { (success, products) in
            guard success, let products = products else { return }
            PurchaseProduct.availableProducts = products
        }
    }
}
