//
//  Address.swift
//  ShopifyApp
//
//  Created by David Muzi on 2019-08-21.
//  Copyright © 2019 Shopify. All rights reserved.
//

import Foundation

struct Address: Decodable, Identifiable {
	let id: Int
	let address1: String?
	let address2: String?
	let city: String?
	let province: String?
	let zip: String?
	let country: String
}
