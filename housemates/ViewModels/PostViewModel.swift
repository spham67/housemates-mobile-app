//
//  GroupViewModel.swift
//  housemates
//
//  Created by Daniel Fransesco Gunawan on 11/13/23.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

class PostViewModel: ObservableObject {
    private let postRepository = PostRepository()
    
    @Published var posts: [Post] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        postRepository.$posts
            .receive(on: DispatchQueue.main)
            .sink { updatedPosts in
                self.posts = updatedPosts
            }
            .store(in: &self.cancellables)
        
    }
    
    func create(post: Post) {
        postRepository.create(post)
    }
    
    
}


extension PostViewModel {
    static func mock() -> PostViewModel {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy h:mm a"
        let formattedDate = formatter.string(from: Date())
        let mockUser =  User(id: "test", first_name: "test", last_name: "test", phone_number: "test", email: "test", birthday: "test", group_id: "test")
        let mockTask =  task(name: "Wash The Dishes", group_id: "test", user_id: "test", description: "Wash Dishes and put back into cabinets", status: .done, date_started: nil, date_completed: formattedDate, priority: "High")
        let mockPosts = [Post(task: mockTask, group_id: "test", created_by: mockUser, num_likes: 0, num_comments: 0, liked_by: [], comments: [])]
        let mockPostViewModel = PostViewModel()
        mockPostViewModel.posts = mockPosts
        return mockPostViewModel
    }
    
    static func mockPost() -> Post {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yy h:mm a"
        let formattedDate = formatter.string(from: Date())
        let mockUser =  User(id: "test", first_name: "test", last_name: "test", phone_number: "test", email: "test", birthday: "test", group_id: "test")
        let mockTask =  task(name: "Wash The Dishes", group_id: "test", user_id: "test", description: "Wash Dishes and put back into cabinets", status: .done, date_started: nil, date_completed: formattedDate, priority: "High")
        return Post(task: mockTask, group_id: "test", created_by: mockUser, num_likes: 0, num_comments: 0, liked_by: [], comments: [])
    }
}

