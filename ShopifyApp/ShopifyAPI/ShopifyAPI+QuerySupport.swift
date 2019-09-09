//
//  ShopifyAPI+QuerySupport.swift
//  ShopifyApp
//
//  Created by David Muzi on 2019-08-22.
//  Copyright © 2019 Shopify. All rights reserved.
//

import Foundation

public protocol Queryable {
	associatedtype Query: QueryItemConvertable
}

public protocol QueryItemConvertable {
	func queryItem() -> URLQueryItem
}

public class QueryBuilder<Q: Queryable> {
	
	public typealias Resource = Q
	
	public init() {}
	
	private var _queryItems = [Q.Query]()
	
	public func addQuery(_ item: Q.Query) -> QueryBuilder {
		_queryItems.append(item)
		return self
	}
	
	var queryItems: [URLQueryItem] {
		return _queryItems.map{ $0.queryItem() }
	}
}
