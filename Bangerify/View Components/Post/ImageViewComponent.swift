//
//  ImageViewComponent.swift
//  Bangerify
//
//  Created by David Kasperek on 28/03/2023.
//

import SwiftUI
import Kingfisher

struct ImageViewComponent: View {
    var post: PostObject
    var images: [URL]
    @State private var index = 0
    
    var body: some View {
        VStack {
            if (post.images?.count == 1) {
                KFImage(post.images?.first)
                    .placeholder {
                        Image(systemName: "hourglass")
                            .foregroundColor(.gray)
                    }
                    .cancelOnDisappear(true)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                let firstImageAspectRatio: CGFloat = 1.5 // Replace this value with the actual aspect ratio of the first image
                let carouselHeight = UIScreen.main.bounds.width / firstImageAspectRatio
                
                MultiImageView(images: images, height: carouselHeight, index: $index)
            }
        }
    }
}
