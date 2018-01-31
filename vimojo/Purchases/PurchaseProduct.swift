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
    case removeWatermark = "com.videona.vimojo.RemoveWatermark"
    
    static var availableProducts: [SKProduct] = []
    public static let store = IAPHelper(products: PurchaseProduct.all)

    var productIdentifier: String {
        return self.rawValue
    }
    var notification: String {
        switch self {
        case .removeWatermark: return "ProductPurchaseNotification"
        }
    }
    fileprivate var isEnabledKey: String {
        switch self {
        case .removeWatermark: return "\(self.productIdentifier)isEnabledKey"
        }
    }
    var isEnabled: Bool {
        set { UserDefaults.standard.set(newValue, forKey: isEnabledKey) }
        get { return UserDefaults.standard.bool(forKey: isEnabledKey) }
    }
    var isPurchased: Bool {
        return UserDefaults.standard.bool(forKey: productIdentifier)
    }
    private static var all: Set<PurchaseProduct> {
        return [.removeWatermark]
    }
    public static func isProductPurchased(product: PurchaseProduct) -> Bool {
        return UserDefaults.standard.bool(forKey: product.productIdentifier)
    }
    public static func setEnabled(state: Bool, product: PurchaseProduct) {
        UserDefaults.standard.set(state, forKey: product.isEnabledKey)
    }
    public static func reloadProducts() {
        PurchaseProduct.store.requestProducts { (success, products) in
            guard success, let products = products else { return }
            PurchaseProduct.availableProducts = products
        }
    }
}
