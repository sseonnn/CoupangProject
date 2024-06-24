//
//  FavoriteItemTableViewCell.swift
//  Cproject
//
//  Created by 이정선 on 6/12/24.
//

import UIKit
import Kingfisher

struct FavoriteItemTableViewCellViewModel: Hashable {
    let imageUrl: String
    let productName: String
    let productPrice: String
}

final class FavoriteItemTableViewCell: UITableViewCell {
    static let reusableId: String = "FavoriteItemTableViewCell"
    
    @IBOutlet weak var productPurchaseButton: PurchaseButton!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productItemImageView: UIImageView!
    
    func setViewModel(_ viewModel: FavoriteItemTableViewCellViewModel) {
        self.productItemImageView.kf.setImage(with: URL(string: viewModel.imageUrl))
        self.productTitleLabel.text = viewModel.productName
        self.productPriceLabel.text = viewModel.productPrice
    }
}
