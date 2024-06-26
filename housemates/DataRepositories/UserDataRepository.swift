//
//  UserDataRepository.swift
//  housemates
//
//  Created by Sean Pham on 10/31/23.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserRepository: ObservableObject {
    private let path: String = "users"
    private let store = Firestore.firestore()
    
    @Published var users: [User] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.get()
    }
    
    func get() {
        store.collection(path)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting users: \(error.localizedDescription)")
                    return
                }
                
                self.users = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: User.self)
                } ?? []
                
            }
    }
    // MARK: CRUD methods
    func update(_ user: User) {
        guard let userId = user.id else { return }
        
        do {
          try store.collection(path).document(userId).setData(from: user)
        } catch {
          fatalError("Unable to update user: \(error.localizedDescription).")
        }
      }
    
    func create(_ user: User) {
            do {
                let newUser = user
                _ = try store.collection(path).addDocument(from: newUser)
            } catch {
                fatalError("Unable to add User: \(error.localizedDescription).")
            }
    }
    
    // MARK: Filter methods
    func getUsersForGroup(_ grp_id: String) -> [User] {
       return self.users.filter{$0.group_id == grp_id}
    }
    
}
