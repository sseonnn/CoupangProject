//
//  Numeric+Extensions.swift
//  Cproject
//
//  Created by 이정선 on 6/6/24.
//

import Foundation

extension Numeric {
    var moneyString: String {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        return (formatter.string(for: self) ?? "") + "원"
    }
}
