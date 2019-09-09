//
//  Product.swift
//  ShopifyApp
//
//  Created by David Muzi on 2019-08-21.
//  Copyright © 2019 Shopify. All rights reserved.
//

import Foundation

struct Products: Decodable {
	let products: [Product]
}

struct Product: Decodable, Identifiable {
	let id: Int
	let title: String
	let variants: [Variant]
}

extension Products: Resource {
	static let path = "products"
}

struct Variant: Decodable, Identifiable {
	let id: Int
	let title: String
	let price: String
	let InventoryQuantity: Int?
}

extension Products: Queryable {
		
	public enum Query: QueryItemConvertable {
		case limit(Int)
		case page(Int)
		case productType(String)
		
		public func queryItem() -> URLQueryItem {
			switch self {
			case .limit(let lim): return URLQueryItem(name: "limit", value: "\(lim)")
			case .page(let page): return URLQueryItem(name: "page", value: "\(page)")
			case .productType(let type): return URLQueryItem(name: "product_type", value: "\(type)")
			}
		}
	}
}

extension QueryBuilder where Q == Products {
	var endpoint: Endpoint<Products> {
		return Endpoint<Products>(queryParams: queryItems)
	}
}
