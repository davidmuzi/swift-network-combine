//
//  ShopifyAPI.swift
//  ShopifyApp
//
//  Created by David Muzi on 2019-08-21.
//  Copyright © 2019 Shopify. All rights reserved.
//

import Foundation

enum Credentials {
	case token(String)
	case password(String, String)
}

class ShopifyAPI {
	
	let session: URLSession
	let domain: String
	private let credentials: Credentials
	
	static var shared: ShopifyAPI!

	lazy var decoder: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return decoder
	}()
	
	init(domain: String, credentials: Credentials) {
		self.domain = domain
		self.credentials = credentials
				
		let config = URLSessionConfiguration.default
		
		if case let Credentials.token(token) = credentials {
			config.httpAdditionalHeaders = ["X-Shopify-Access-Token": token]
		}
		
		self.session = URLSession(configuration: config)
	}
	
	func url(path: String) -> URL? {
		var prefix = ""
		if case let .password(username, password) = credentials {
			prefix = username + ":" + password + "@"
		}
		return URL(string: "https://\(prefix)\(domain)/admin/\(path).json")
	}
}

protocol Resource {
	static var path: String { get }
}

typealias DecodableResource = Decodable & Resource

struct Endpoint<T: Resource> {
	let queryParams: [URLQueryItem]
	var path: String { return T.path }
	
	init(queryParams: [URLQueryItem] = []) {
		self.queryParams = queryParams
	}
}

extension Endpoint {
	static func endpoint<R>() -> Endpoint<R> {
		return Endpoint<R>()
	}
}

@_functionBuilder
class APIQueryBuilder {
	static func buildBlock<R: Queryable>(_ children: R.Query...) -> Endpoint<R> {
		let params = children.map { $0.queryItem() }
		return Endpoint<R>(queryParams: params)
	}
}

extension ShopifyAPI {
	func get<R>(@APIQueryBuilder builder: () -> Endpoint<R>) -> ShopifyDataSource<R> {
		return ShopifyDataSource(api: self, endpoint: builder())
	}
}

extension ShopifyAPI {
	func url<R>(endpoint: Endpoint<R>) -> URL? {
		guard let url = url(path: endpoint.path) else { return nil }
		guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
		components.queryItems = endpoint.queryParams
		
		return components.url
	}
	
	func get<R: Decodable>(endpoint: Endpoint<R>, callback: @escaping (R) -> Void) {
		session.dataTask(with: url(path: endpoint.path)!) { data, response, error in
			guard let data = data else { return }
			guard let resource = try? self.decoder.decode(R.self, from: data) else { return }
			callback(resource)
		}
	}
}
