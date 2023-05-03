//
//  MulitImageView.swift
//  Bangerify
//
//  Created by David Kasperek on 20/03/2023.
//

import SwiftUI
import Kingfisher

struct MultiImageView: View {
    let images: [URL]
    let height: CGFloat
    @Binding var index: Int
    
    var body: some View {
        VStack {
            TabView(selection: $index) {
                ForEach(images.indices, id: \.self) { index in
                    KFImage(images[index])
                        .placeholder {
                            Image(systemName: "hourglass")
                                .foregroundColor(.gray)
                        }
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width)
                        .clipped()
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: height + 200)
            
            HStack(spacing: 2) {
                ForEach((0..<images.count), id: \.self) { i in
                    Rectangle()
                        .fill(i == self.index ? Color.accentColor : Color.secondary.opacity(0.5))
                        .frame(width: 30, height: 5)
                }
            }
            .padding(5)
        }
    }
}

struct MulitImageView_Previews: PreviewProvider {
    @State static private var index = 0
    
    static var previews: some View {
        let firstImageAspectRatio: CGFloat = 1.5
        let carouselHeight = UIScreen.main.bounds.width / firstImageAspectRatio
        MultiImageView(images: [URL(string: "https://bangerify-media.s3.eu-central-1.amazonaws.com/8543f960fd209be3389357a9e36e80f4")!, URL(string: "https://bangerify-media.s3.eu-central-1.amazonaws.com/8543f960fd209be3389357a9e36e80f4")!], height: carouselHeight, index: $index)
    }
}
