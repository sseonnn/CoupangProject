//
//  OptionRootView.swift
//  Cproject
//
//  Created by 이정선 on 6/21/24.
//

import SwiftUI

struct OptionRootView: View {
    @ObservedObject var viewModel: OptionViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    OptionRootView(viewModel: OptionViewModel())
}
