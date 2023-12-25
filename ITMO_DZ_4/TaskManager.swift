import Foundation

protocol Task: AnyObject {
    var priority: Int { get }
    var dependencies: [Task] { get }
    func execute()
    func addDependency(_ task: Task)
}

class BasicTask: Task {
    var priority: Int
    var dependencies: [Task] = []
    private let action: () -> Void

    init(priority: Int, action: @escaping () -> Void) {
        self.priority = priority
        self.action = action
    }

    func execute() {
        action()
    }

    func addDependency(_ task: Task) {
        dependencies.append(task)
    }
}

class TaskManager {
    private var visited: Set<ObjectIdentifier> = []

    func add(_ task: Task) {
        execute(task)
    }

    private func execute(_ task: Task) {
        let taskId = ObjectIdentifier(task)
        guard !visited.contains(taskId) else { return }
        visited.insert(taskId)

        let sortedDependencies = task.dependencies.sorted { $0.priority > $1.priority }
        for dependency in sortedDependencies {
            execute(dependency)
        }

        task.execute()
    }
}
