//
//  pop.swift
//  In App purchase practice
//
//  Created by Bilal Ahmed on 09/03/2023.
//

import Foundation

import SwiftUI
import StoreKit

struct pop: View {
    @StateObject var storeManager = StoreManager()
    let storeObserver = StoreObserver()

    var body: some View {
        NavigationView{
            
            
            VStack {
                ForEach(storeManager.products, id: \.self) { product in
                  
                    Text(product.localizedTitle)
                    
                    
                }
                
                Button("Purchase") {
                    purchaseProduct(product: storeManager.products.first!)
                           }
            }
            .onAppear {
                storeManager.fetchProducts()
            }
        }
        
    }
    func purchaseProduct(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        SKPaymentQueue.default().add(storeObserver)
    }
}



class StoreManager: NSObject, ObservableObject, SKProductsRequestDelegate {
    @Published var products = [SKProduct]()
    var request: SKProductsRequest!
    
    func fetchProducts() {
        let productIdentifiers = Set(["com.yourcompany.yourapp.product1", "com.yourcompany.yourapp.product2"])
        request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
        }
    }
}


class StoreObserver: NSObject, SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                // Handle successful purchase
                queue.finishTransaction(transaction)
            case .failed:
                // Handle failed purchase
                queue.finishTransaction(transaction)
            case .restored:
                // Handle restored purchase
                queue.finishTransaction(transaction)
            default:
                break
            }
        }
    }
}
