//
//  CustomerView2.swift
//  ShopifyApp
//
//  Created by David Muzi on 2019-08-23.
//  Copyright © 2019 Shopify. All rights reserved.
//

import SwiftUI
import Combine

struct CustomersView : View {
	
	@APIRequest(endpoint) var request: AnyPublisher<Customers?, Never>
	@State private var customers = [Customer]()
	
	@APIQueryBuilder
	static var endpoint: Endpoint<Customers> {
		CustomerQuery.limit(5)
		CustomerQuery.page(3)
	}
	
	var body: some View {
		List(customers, rowContent: CustomerRow.init)
			.onAppear {
				_ = self.request
					.compactMap { $0?.customers }
					.assign(to: \.customers, on: self)
		}
	}
}

struct CustomerRow: View {
	let customer: Customer
	
	var body: some View {
		VStack(alignment: .leading) {
			Text(customer.firstName ?? "" + " " + (customer.lastName ?? ""))
				.font(.headline)
			Text(customer.email ?? "no email")
				.font(.subheadline)
				.foregroundColor(.gray)
		}
	}
}
