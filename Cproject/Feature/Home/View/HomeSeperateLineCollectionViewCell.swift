//
//  HomeSeperateLineCollectionViewCell.swift
//  Cproject
//
//  Created by 이정선 on 6/7/24.
//

import UIKit

struct HomeSeperateLineCollectionViewCellModel: Hashable {
}

class HomeSeperateLineCollectionViewCell: UICollectionViewCell {
    static let reusableId: String = "HomeSeperateLineCollectionViewCell"
    
    func setModel(_ model: HomeSeperateLineCollectionViewCellModel) {
        contentView.backgroundColor = CPColor.UIKit.gray1
    }
}

extension HomeSeperateLineCollectionViewCell {
    static func seperateLineLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(11))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 20, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
}
