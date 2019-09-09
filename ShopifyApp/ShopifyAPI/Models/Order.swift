//
//  Order.swift
//  ShopifyApp
//
//  Created by David Muzi on 2019-08-21.
//  Copyright © 2019 Shopify. All rights reserved.
//

import Foundation

struct Orders: Decodable {
	let orders: [Order]
}

struct Order: Decodable, Identifiable {
	let id: Int
	let number: Int
	let email: String
	let totalPrice: String?
	let createdAt: Date
	let customer: Customer?
	let lineItems: [Variant]

	enum FinancialStatus: String, Decodable {
		case paid, pending, authorized, refunded, voided, partiallyRefunded = "partially_refunded", partiallyPaid = "partially_paid"
	}
	let fulfillmentStatus: FulfillmentStatus?

	enum FulfillmentStatus: String, Decodable {
		case fulfilled, unfulfilled, restocked
	}
	let financialStatus: FinancialStatus
}

extension Orders: Resource {
	static let path = "orders"
}

extension Orders: Queryable {
	
	public enum Status: String {
		case open, closed, cancelled
	}
	
	public enum Query: QueryItemConvertable {
		case limit(Int)
		case page(Int)
		case status(Status)
		
		public func queryItem() -> URLQueryItem {
			switch self {
			case .limit(let lim): return URLQueryItem(name: "limit", value: "\(lim)")
			case .page(let page): return URLQueryItem(name: "page", value: "\(page)")
			case .status(let status): return URLQueryItem(name: "status", value: status.rawValue)
			}
		}
	}
}
