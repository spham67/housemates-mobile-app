//
//  AuthViewModel.swift
//  housemates
//
//  Code referenced from https://www.youtube.com/watch?v=QJHmhLGv-_0&ab_channel=AppStuff
//  Created by Sean Pham on 10/31/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

protocol AuthenticationFormProtocol {
    var formisValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    private let userRepository = UserRepository()
    private let groupRepository = GroupRepository()

    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var isLoading = false
    
    func fetchUser() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
    init () {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("Failed to log in: \(error.localizedDescription)")
        }
    }
    
    // TODO: Change birthday to date type and phone_number to int
    func createUser(withEmail email: String, username: String, password: String, first_name: String, last_name: String, phone_number: String, birthday: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, user_id: result.user.uid, username: username, first_name: first_name, last_name: last_name, phone_number: phone_number, email: email, birthday: birthday)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id!).setData(encodedUser)
                        
            await fetchUser()
        }  catch {
            print("Failed to create user: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("Failed to sign out: \(error.localizedDescription)")
        }
    }
    
    func saveProfilePicture(image: UIImage) async -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("ERROR: Counld not get current user ID")
            return false
        }
        
        let photoID = UUID().uuidString
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(photoID).jpeg")
        
        guard let resizedImage = image.jpegData(compressionQuality: 0.2) else {
            print("ERROR: Could not resize image")
            return false
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        var imageURLString = ""
        
        // MARK: Save image to Storage and get URL
        do {
            let _ = try await storageRef.putDataAsync(resizedImage, metadata: metadata)
            do {
                let imageURL = try await storageRef.downloadURL()
                imageURLString = "\(imageURL)"
            } catch {
                print("ERROR: Could not get imageURL after saveing image \(error.localizedDescription)")
                return false
            }
        } catch {
            print("ERROR: Could not upload image to FirebaseStorage")
            return false
        }
        
        // MARK: Update user struct and Firestore document
        do {
            try await Firestore.firestore().collection("users").document(uid).setData(["imageURLString": imageURLString], merge: true)
            await fetchUser()
            return true
        } catch {
            print("ERROR: Could not update data for user")
            return false
        }
    }

}


extension AuthViewModel {
    static func mock() -> AuthViewModel {
        // Create and return a mock AuthViewModel with a mock user
        let mockUser =  User(id: "xkP2L9pIp5cklnQDD4JYXv0Tow02",
                             user_id: "xkP2L9pIp5cklnQDD4JYXv0Tow02", username: "seanp",
                             first_name: "Sean",
                             last_name: "Pham",
                             phone_number: "1234567899",
                             email: "sean@gmail.com",
                             birthday:  "01-01-2000",
                             group_id: "wwyqNgGYFXMCpMcr9jvI",
                             imageURLString: "https://firebasestorage.googleapis.com:443/v0/b/housemates-3b4be.appspot.com/o/E07030F1-2EDB-46EE-94E1-44C2C8F1D298.jpeg?alt=media&token=208753fd-eb63-4e47-b40e-7fb33ca7345d")
        let mockAuthViewModel = AuthViewModel()
        mockAuthViewModel.currentUser = mockUser
        return mockAuthViewModel
    }
}
