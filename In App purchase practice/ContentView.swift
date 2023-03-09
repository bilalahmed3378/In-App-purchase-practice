//
//  ContentView.swift
//  In App purchase practice
//
//  Created by Bilal Ahmed on 09/03/2023.
//

import SwiftUI
import StoreKit



struct ContentView: View {
    @StateObject var viewModel = ViewModel()
   
   
    var body: some View {
        NavigationView{
            
            VStack{
                
                if let product = viewModel.products.first{
                    Text(product.displayName)
                    Text(product.description)
                    Button(action: {
                        if viewModel.purchasedIds.isEmpty{
                            viewModel.purchase()
                        }
                    }, label: {
                        Text(viewModel.purchasedIds.isEmpty ? "Buy Now \(product.displayPrice)" : "Purchsed")
                        
                    })
                   
                }
               
                
            }
            .onAppear{
                viewModel.fetchProducts()
                
            }
            
        }
    }
   
}


class ViewModel : ObservableObject {
   @Published var products : [Product] = []
    @Published var purchasedIds : [String] = []

    func fetchProducts(){
        async{
            do{
                let products = try await Product.products(for: ["com.temporary.id_neww"])
                DispatchQueue.main.async {
                    self.products = products
                }
                if let product = products.first{
                    await isPurchased(product : product)
                }
            }
            catch{
                print(error)
            }
        }
    }
    func isPurchased(product : Product) async {
        
       
           guard let state = await product.currentEntitlement
            else{
               return
           }
        print("Checking state")
            switch state {
            case .verified(let transaction):
                DispatchQueue.main.async {
                    self.purchasedIds.append(transaction.productID)
                }
            case .unverified(_):
                break
            
            }
        
    }
    
    func purchase(){
        async{
            guard let product = products.first else {return}
        do{
            let result = try await product.purchase()
            switch result {
                
            case .success(let verification) :
                switch verification {
                case .verified(let transaction) :
                    DispatchQueue.main.async {
                        self.purchasedIds.append(transaction.productID)
                    }
                case .unverified(_) :
                    break
                }
            case .userCancelled :
                break
            case .pending :
                break
            @unknown default:
                break
            }
        }
        catch{
            print(error)
        }
    }
    }
}

