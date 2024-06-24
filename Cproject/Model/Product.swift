//
//  Product.swift
//  Cproject
//
//  Created by 이정선 on 6/11/24.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let imageUrl: String
    let title: String
    let discount: String
    let originalPrice: Int
    let discountPrice: Int
}
