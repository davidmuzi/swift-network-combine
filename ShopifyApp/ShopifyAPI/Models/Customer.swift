//
//  Customer.swift
//  ShopifyApp
//
//  Created by David Muzi on 2019-08-21.
//  Copyright © 2019 Shopify. All rights reserved.
//

import Foundation

struct Customers: Decodable {
	let customers: [Customer]
}

struct Customer: Decodable, Identifiable {
	let id: Int
	let email: String?
	let firstName: String?
	let lastName: String?
	let addresses: [Address]?
	let primaryAddress: Address?
}

extension Customers: Resource {
	static let path = "customers"
}

typealias CustomerQuery = Customers.Query
extension Customers: Queryable {
	public enum Query: QueryItemConvertable {
		case limit(Int)
		case page(Int)
		
		public func queryItem() -> URLQueryItem {
			switch self {
			case .limit(let lim): return URLQueryItem(name: "limit", value: "\(lim)")
			case .page(let page): return URLQueryItem(name: "page", value: "\(page)")
			}
		}
	}
}
