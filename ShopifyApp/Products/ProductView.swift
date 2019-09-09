//
//  ProductView.swift
//  ShopifyApp
//
//  Created by David Muzi on 2019-08-21.
//  Copyright © 2019 Shopify. All rights reserved.
//

import SwiftUI

struct ProductView : View {
	
	@ObservedObject var dataSource: ShopifyDataSource<Products>
	
	init(api: ShopifyAPI) {
		let productItems = QueryBuilder<Products>()
			.addQuery(.limit(10))
		
		self.dataSource = ShopifyDataSource(api: api, endpoint: productItems.endpoint)
	}
	
	var body: some View {
		Group {
			if dataSource.resource == nil {
				Text("Loading...")
			} else {
				List(dataSource.resource!.products) { product in
					NavigationLink(destination: ProductDetailView(product: product)) {
						ProductRow(product: product)
					}
				}
			}
		}
	}
}

struct ProductRow: View {
	let product: Product
	
	var body: some View {
		Text(product.title)
	}
}

struct ProductDetailView: View {
	let product: Product
	
	var body: some View {
		VStack {
			Text(product.title)
				.font(.headline)
			List(product.variants, rowContent: VariantRow.init)
		}
	}
}

struct VariantRow: View {
	let variant: Variant
	
	var body: some View {
		HStack {
			Text(variant.title)
			Spacer()
			Text("$" + variant.price)
				.font(.subheadline)
		}
	}
}
