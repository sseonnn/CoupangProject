//
//  ProductDetailResponse.swift
//  Cproject
//
//  Created by 이정선 on 6/14/24.
//

import Foundation

struct ProductDetailResponse: Decodable {
    var bannerImages: [String]
    var product: ProductDetail
    var option: ProductDetailOption
    var detailImages: [String]
}

struct ProductDetail: Decodable {
    var name: String
    var discountPercent: Int
    var originalPrice: Int
    var discountPrice: Int
    var rate: Int
}

struct ProductDetailOption: Decodable {
    var type: String
    var name: String
    var image: String
}
