//
//  OrderRow.swift
//  ShopifyApp
//
//  Created by David Muzi on 2019-08-22.
//  Copyright © 2019 Shopify. All rights reserved.
//

import SwiftUI


struct OrderRow: View {
	let order: Order
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("#\(order.number)")
				.font(.footnote)
			HStack {
				Text(order.customer?.firstName ?? "")
				Spacer()
				Text("$" + (order.totalPrice ?? ""))
			}
			.font(.headline)
			HStack {
				Text(order.financialStatus.displayString)
				Text(order.fulfillmentStatus?.displayString ?? "")
			}
			.font(.subheadline)
			.foregroundColor(.gray)
		}
	}
}

extension Order.FinancialStatus {
	var displayString: String {
		switch self {
		case .paid: return "Paid"
		case .pending: return "Pending"
		case .partiallyRefunded: return "Partially refunded"
		case .partiallyPaid: return "Partially paid"
		case .authorized: return "Authorized"
		case .refunded: return "Refunded"
		case .voided: return "Void"
		}
	}
}

extension Order.FulfillmentStatus {
	var displayString: String {
		switch self {
		case .fulfilled: return "Fulfilled"
		case .unfulfilled: return "Unfulfilled"
		case .restocked: return "Restocked"
		}
	}
}
