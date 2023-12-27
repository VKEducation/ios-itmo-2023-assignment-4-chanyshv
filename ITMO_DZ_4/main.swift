import Foundation

let manager = TaskManager()
let taskA = BasicTask(priority: 1) { print("Executing Task A") }
let taskB = BasicTask(priority: 2) { print("Executing Task B") }
let taskC = BasicTask(priority: 3) { print("Executing Task C") }

taskA.addDependency(taskB)
taskA.addDependency(taskC)

manager.add(taskA)
