//
//  HomeCouponButtonCollectionViewCell.swift
//  Cproject
//
//  Created by 이정선 on 6/6/24.
//

import UIKit
import Combine

struct HomeCouponButtonCollectionViewCellModel: Hashable {
    enum CouponState {
        case enable
        case disable
    }
    var state: CouponState
}

final class HomeCouponButtonCollectionViewCell: UICollectionViewCell {
    static let reusableId: String = "HomeCouponButtonCollectionViewCell"
    private weak var didTapCouponDownload: PassthroughSubject<Void, Never>?
    
    @IBOutlet weak var couponButton: UIButton! {
        didSet {
            couponButton.setImage(CPImage.buttonActivate, for: .normal)
            couponButton.setImage(CPImage.buttonComplete, for: .disabled)
        }
    }
    
    func setModel(
        _ model: HomeCouponButtonCollectionViewCellModel,
        _ didTapCouponDownload: PassthroughSubject<Void, Never>?
    ) {
        couponButton.isEnabled = switch model.state {
        case .enable:
            true
        case .disable:
            false
        }
        
        self.didTapCouponDownload = didTapCouponDownload
    }
    
    @IBAction private func didTapCouponButton(_ sender: Any) {
        didTapCouponDownload?.send()
    }
}

extension HomeCouponButtonCollectionViewCell {
    static func couponLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(37))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 28, leading: 22, bottom: 0, trailing: 22)
        
        return section
    }
}
