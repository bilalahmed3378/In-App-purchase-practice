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
            
            Button(action: {
                viewModel.purchase()
            }, label: {
                Text("Buy")

            })
            .onAppear{
                viewModel.fetchProducts()

            }
          
        }
    
        
    }
   
}


class ViewModel : ObservableObject {
    var products : [Product] = []
    func fetchProducts(){
        async{
            do{
                let products = try await Product.products(for: ["com.temporary.id"])
                self.products = products
            }
            catch{
                print(error)
            }
        }
    }
    func purchase(){
        async{
            guard let product = products.first else {return}
        do{
            let result = try await product.purchase()
        }
        catch{
            print(error)
        }
    }
    }
}

