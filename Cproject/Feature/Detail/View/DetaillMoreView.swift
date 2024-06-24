//
//  DetaillMoreView.swift
//  Cproject
//
//  Created by 이정선 on 6/17/24.
//

import SwiftUI

final class DetaillMoreViewModel: ObservableObject {
    
}

struct DetaillMoreView: View {
    @ObservedObject var viewModel: DetaillMoreViewModel
    var onMoreTapped: () -> Void
    
    var body: some View {
        Button {
            onMoreTapped()
        } label: {
            HStack(alignment: .center, spacing: 10) {
                Text("상품정보 더보기")
                    .font(CPFont.SwiftUI.b17)
                    .foregroundStyle(CPColor.SwiftUI.keyColorBlue)
                Image(.down)
                    .foregroundColor(CPColor.SwiftUI.gray5)
            }
            .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
            .border(CPColor.SwiftUI.keyColorBlue, width: 1)
        }

    }
}

#Preview {
    DetaillMoreView(viewModel: DetaillMoreViewModel(), onMoreTapped: {})
}
