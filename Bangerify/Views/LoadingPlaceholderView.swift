//
//  LoadingPlaceholderView.swift
//  Bangerify
//
//  Created by David Kasperek on 06/05/2023.
//

import SwiftUI

struct LoadingPlaceholderView: View {
    var body: some View {
        VStack {
            Image("icon")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .padding(.bottom, 25)
            ProgressView()
        }
    }
}

struct LoadingPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingPlaceholderView()
    }
}

