//
//  TaskViewModel.swift
//  housemates
//
//  Created by Sanmoy Karmakar on 11/3/23.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

class TaskViewModel: ObservableObject {
    private let taskRepository = TaskRepository()
    
    @Published var tasks: [task] = []
    private var cancellables: Set<AnyCancellable> = []

    init() {
        taskRepository.$tasks
            .receive(on: DispatchQueue.main)
            .sink { updatedTasks in
                self.tasks = updatedTasks
            }
            .store(in: &self.cancellables)
    }
    
    func getTasksForGroup(_ group_id: String) -> [task] {
      return self.tasks.filter { $0.group_id == group_id}
    }

    func getUnclaimedTasksForGroup(_ group_id: String) -> [task] {
        return self.tasks.filter { $0.group_id == group_id && $0.status == .unclaimed}
    }

    func getInProgressTasksForGroup(_ group_id: String) -> [task] {
        return self.tasks.filter { $0.group_id == group_id && $0.status == .inProgress}
    }

    func getCompletedTasksForGroup(_ group_id: String) -> [task] {
        return self.tasks.filter { $0.group_id == group_id && $0.status == .done}
    }

    func isMyTask(task: task, user_id: String) -> Bool {
      return task.user_id == user_id
    }

    func claimTask(task: task) {
        var task = task
        task.date_started = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
        task.date_completed = nil
        task.status = .inProgress
        taskRepository.update(task)
    }
    
    func completeTask(task: task) {
        var task = task
        task.date_started = nil
        task.date_completed = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
        task.status = .done
        taskRepository.update(task)
      }
    
    func create(task: task) {
        taskRepository.create(task)
    }
    
    func destroy(task: task) {
        taskRepository.delete(task)
    }
    
  }
