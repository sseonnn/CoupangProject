//
//  HomeThemeCollectionViewCell.swift
//  Cproject
//
//  Created by 이정선 on 6/9/24.
//

import UIKit
import Kingfisher

struct HomeThemeCollectionViewCellModel: Hashable {
    let imageUrl: String
}

final class HomeThemeCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var themeImageView: UIImageView!
    static let reusableId: String = "HomeThemeCollectionViewCell"
    
    func setModel(_ model: HomeThemeCollectionViewCellModel) {
        self.themeImageView.kf.setImage(with: URL(string: model.imageUrl))
    }
}

extension HomeThemeCollectionViewCell {
    static func seperateLineLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupFractionWidth: CGFloat = 0.7
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionWidth), heightDimension: .fractionalWidth((142 / 286) * groupFractionWidth))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = .init(top: 35, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = 16
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(65))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}
