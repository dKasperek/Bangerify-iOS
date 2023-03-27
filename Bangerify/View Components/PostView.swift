//
//  PostView.swift
//  Bangerify
//
//  Created by David Kasperek on 28/01/2023.
//

import Foundation
import SwiftUI
import Network
import MarkdownUI
import Kingfisher
import Combine

public struct PostView: View {
    
    var post: Post
    @ObservedObject var viewModel: PostViewModel
    @State private var index = 0
    
    public init(post: Post) {
        self.post = post
        self.viewModel = PostViewModel(post: post)
    }
    
    public var body: some View {
        VStack {
            ZStack {
                NavigationLink(destination: ProfileView(username: post.username)) {
                    HStack {
                        if let url = URL(string: post.profilePictureUrl ?? "") {
                            KFImage(url)
                                .placeholder {
                                    Image(systemName: "hourglass")
                                        .foregroundColor(.gray)
                                }
                                .cancelOnDisappear(true)
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .foregroundColor(.gray)
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                        }
                        
                        VStack (alignment: .leading){
                            HStack {
                                Text(post.visible_name)
                                    .font(.headline)
                                    .foregroundColor(getGradeColor(grade: post.grade))
                                Spacer()
                                Image(systemName: "ellipsis")
                                    .font(Font.system(.caption))
                                    .foregroundColor(.secondary)
                            }
                            HStack {
                                Text("@" + post.username).font(.subheadline)
                                Spacer()
                                Text(formatDate(dateString: post.date))
                                    .font(.caption)
                                    .fontWeight(.light)
                                    .foregroundColor(.secondary)
                                
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                    } .padding(5)
                }.buttonStyle(PlainButtonStyle())
            }
            
            ForEach(divideToArray(rawString: post.text), id: \.self) { item in
                if item.hasPrefix("!["){
                    let startIndex = item.firstIndex(of: "(")
                    let url = String(item[startIndex!...])
                    KFImage(URL(string: String(url.dropFirst())))
                        .placeholder {
                            Image(systemName: "hourglass")
                                .foregroundColor(.gray)
                        }
                        .cancelOnDisappear(true)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                else {
                    Markdown(item)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }.id(post.id)
                .padding(5)
            
            if let images = post.images, !images.isEmpty {
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
            
            HStack {
                Button(action: toggleLike) {
                    if (viewModel.liked == 1) {
                        Image(systemName: "heart.fill")
                            .font(Font.system(.title3))
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: "heart")
                            .font(Font.system(.title3))
                            .foregroundColor(.primary)
                    }
                }
                Text(String(viewModel.likes))
                
                Spacer()
                
                if (viewModel.comments?.isEmpty == false) {
                    Image(systemName: "bubble.left.fill")
                        .font(Font.system(.title3))
                    Text(String(viewModel.comments!.count)).font(Font.system(.title3))
                } else {
                    Image(systemName: "bubble.left")
                        .font(Font.system(.title3))
                    Text(String(0)).font(Font.system(.title3))
                }
                
            } .frame(maxWidth: .infinity, alignment: .leading)
                .padding(5)
            if viewModel.comments != nil {
                CommentView(comList: viewModel.comments!)
                    .padding(.bottom, 5)
            }
        }
        .padding(5)
        .padding(.top, 10)
        .onReceive(viewModel.$post) { _ in
            viewModel.loadData()
        }
    }
    
    func toggleLike() {
        LikeService.shared.setLike(for: post.id) {
            if viewModel.liked == 1 {
                viewModel.liked = 0
                viewModel.likes -= 1
            } else {
                viewModel.liked = 1
                viewModel.likes += 1
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var post = Post(
        id: 138,
        text: "**Daily żarcik:**\n\nCo mówi młynarz widzący małpy w zoo?\n> dużo mąki",
        date: "2023-01-30T13:11:23.000Z",
        images: [URL(string: "https://bangerify-media.s3.eu-central-1.amazonaws.com/8543f960fd209be3389357a9e36e80f4")!, URL(string: "https://bangerify-media.s3.eu-central-1.amazonaws.com/8543f960fd209be3389357a9e36e80f4")!],
        userId: 5,
        username: "wojciehc",
        visibleName: "wojciech",
        profilePictureUrl: "https://f4.bcbits.com/img/a0340908479_7.jpg",
        likes: 3,
        liked: 1,
        grade: 4
    )
    
    static var previews: some View {
        PostView(post: post)
    }
}
