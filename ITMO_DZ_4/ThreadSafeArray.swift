import Foundation

class ThreadSafeArray<T> {
    private var array: [T] = []
    private let lock = NSLock()

    func append(_ item: T) {
        lock.lock()
        array.append(item)
        lock.unlock()
    }

    func remove(at index: Int) {
        lock.lock()
        array.remove(at: index)
        lock.unlock()
    }
}

extension ThreadSafeArray: RandomAccessCollection {
    typealias Index = Int
    typealias Element = T

    var startIndex: Index {
        lock.lock()
        defer { lock.unlock() }
        return array.startIndex
    }

    var endIndex: Index {
        lock.lock()
        defer { lock.unlock() }
        return array.endIndex
    }

    subscript(index: Index) -> Element {
        get {
            lock.lock()
            defer { lock.unlock() }
            return array[index]
        }
    }

    func index(after i: Index) -> Index {
        lock.lock()
        defer { lock.unlock() }
        return array.index(after: i)
    }
}
