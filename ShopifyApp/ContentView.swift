//
//  ContentView.swift
//  ShopifyApp
//
//  Created by David Muzi on 2019-08-21.
//  Copyright © 2019 Shopify. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
	var shopifyAPI: ShopifyAPI
	
	var body: some View {
		TabView(selection: $selection) {
			NavigationView {
				OrdersView(api: shopifyAPI)
					.navigationBarTitle(Text("Orders"))
			}
			.tag(0)
			.tabItem {
				VStack {
					Image(systemName: "tray")
					Text("Orders")
				}
			}

			NavigationView {
				ProductView(api: shopifyAPI)
				.navigationBarTitle(Text("Products"))

			}
			.tag(1)
			.tabItem {
				VStack {
					Image(systemName: "bag")
					Text("Products")
				}
			}
			NavigationView {
				CustomersView()
				.navigationBarTitle(Text("Customers"))

			}
			.tag(2)
			.tabItem {
				VStack {
					Image(systemName: "person")
					Text("Customers")
				}
			}
		}
    }
}

