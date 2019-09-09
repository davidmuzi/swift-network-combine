//
//  OrdersView.swift
//  ShopifyApp
//
//  Created by David Muzi on 2019-08-21.
//  Copyright © 2019 Shopify. All rights reserved.
//

import SwiftUI

struct OrdersView : View {
	
	@ObservedObject var dataSource: ShopifyDataSource<Orders>
	
	init(api: ShopifyAPI) {
		self.dataSource = api.get {
			Orders.Query.limit(4)
			Orders.Query.status(.closed)
		}
	}
	
	var body: some View {
		Group {
			if dataSource.resource == nil {
				Text("Loading...")
			} else {
				List(dataSource.resource!.orders, rowContent: OrderRow.init)
			}
		}
	}
}
