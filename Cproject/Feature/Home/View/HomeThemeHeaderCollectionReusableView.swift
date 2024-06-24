//
//  HomeThemeHeaderCollectionReusableView.swift
//  Cproject
//
//  Created by 이정선 on 6/9/24.
//

import UIKit

struct HomeThemeHeaderCollectionReusableViewModel {
    var headerText: String
}

final class HomeThemeHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var themeHeaderLabel: UILabel!
    static let reusableId: String = "HomeThemeHeaderCollectionReusableView"

    func setModel(_ model: HomeThemeHeaderCollectionReusableViewModel) {
        self.themeHeaderLabel.text = model.headerText
    }
}
