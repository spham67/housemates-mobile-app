//
//  PostComponent.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/13/23.
//

import SwiftUI

struct PostRowView: View {
    @EnvironmentObject var postViewModel : PostViewModel
    @State var isCommentDetailSheetPresented = false
    
    let post : Post
    let user : User
    var body: some View {
        // MARK: Profile Picture for post user
        VStack {
            HStack(alignment: .top, spacing: 10) {
                let imageURL = URL(string: post.created_by.imageURLString ?? "")
                
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } placeholder: {
        
                    // MARK: Default user profile picture
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                
                
                VStack(alignment: .leading, spacing: 5) {
                    // MARK: Post Text Details
                    Text("**\(post.created_by.first_name)** completed the task: **\(post.task.name)**")
                        .font(.system(size: 14))
                        .padding(.trailing)
                        .padding(.bottom, 30)
                   
                    // MARK: Comment, Like and Time compontnets
                    HStack(alignment: .bottom) {
                        likeButton(post: post, user: user)
                       
                        // MARK: Comment Button
                        commentButton(post: post, user: user)
                        
                        Spacer()
                        
                        if let date = post.task.date_completed {
                            Text(date)
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .padding(.trailing)
                        }
                    }
                       
                }
            }
        }
    }
    
    // MARK: Like / Unlike Button
    private func likeButton(post: Post, user: User) -> some View {
        HStack {
                // MARK: If user has liked post show unlike button else show like button
                if post.liked_by.contains(where: {$0 == user.id}) {
                    Button(action: {
                        postViewModel.unlikePost(user: user, post: post)
                    }) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 20))
                    }.buttonStyle(PlainButtonStyle()) // Allows button on list view to be independent
                } else {
                    Button(action: {
                        postViewModel.likePost(user: user, post: post)
                    }) {
                        Image(systemName: "heart")
                            .font(.system(size: 20))
                    }.buttonStyle(PlainButtonStyle()) // Allows button on list view to be independent
                }
                
                // MARK: Like count
                if !post.liked_by.isEmpty {
                    Text(String(post.num_likes))
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
        }
    }
    
    // MARK: Comment Button
    private func commentButton(post: Post, user: User) -> some View {
        HStack {
            Button(action: {
                isCommentDetailSheetPresented = true
            }) {
                Image(systemName: "bubble.right")
                    .font(.system(size: 18))
            }.buttonStyle(PlainButtonStyle())
            
            if !post.comments.isEmpty {
                Text(String(post.num_comments))
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Spacer()
        }.sheet(isPresented: $isCommentDetailSheetPresented) {
                CommentDetailView(post: post, user: user)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.automatic)
            }
        
        }
}



struct PostComponent_Previews: PreviewProvider {
    static var previews: some View {
        PostRowView(post: PostViewModel.mockPost(), user: UserViewModel.mockUser())

    }
}