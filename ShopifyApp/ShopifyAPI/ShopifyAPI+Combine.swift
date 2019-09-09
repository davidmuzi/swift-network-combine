//
//  ShopifyAPI+Combine.swift
//  ShopifyApp
//
//  Created by David Muzi on 2019-08-21.
//  Copyright © 2019 Shopify. All rights reserved.
//

import Foundation
import Combine

class ShopifyDataSource<R: DecodableResource>: ObservableObject {

	private let api: ShopifyAPI
	private var subscriber: Cancellable?
	private let endpoint: Endpoint<R>
	
	var objectWillChange = PassthroughSubject<R?, Never>()
	
	init(api: ShopifyAPI, endpoint: Endpoint<R>) {
		self.api = api
		self.endpoint = endpoint
		fetch()
	}
	
	var resource: R? { didSet { objectWillChange.send(resource) } }

	var publisher: AnyPublisher<R?, Never> {
		let url = api.url(endpoint: endpoint)!
		return api.session.dataTaskPublisher(for: url)
			.map { $0.data }
			.decode(type: R.self, decoder: api.decoder)
			.map { $0 }
			.replaceError(with: nil)
			.receive(on: RunLoop.main)
			.eraseToAnyPublisher()
	}
	
	func fetch() {
		subscriber = publisher.assign(to: \.resource, on: self)
	}
}

@propertyWrapper
class APIRequest<R: DecodableResource> {

	private var dataSource: ShopifyDataSource<R>
	
	init(_ endpoint: Endpoint<R>, api: ShopifyAPI = .shared) {
		self.dataSource = ShopifyDataSource(api: api, endpoint: endpoint)
	}

	var wrappedValue: AnyPublisher<R?, Never> {
		return dataSource.publisher
	}
}
