import Foundation

class ThreadSafeArray<T> {
    private var array: [T] = []
    private var lock = pthread_rwlock_t()
    private var attr = pthread_rwlockattr_t()

    init() {
        pthread_rwlockattr_init(&attr)
        pthread_rwlock_init(&lock, &attr)
    }

    deinit {
        pthread_rwlock_destroy(&lock)
        pthread_rwlockattr_destroy(&attr)
    }

    func append(_ item: T) {
        pthread_rwlock_wrlock(&lock)
        array.append(item)
        pthread_rwlock_unlock(&lock)
    }

    func remove(at index: Int) {
        pthread_rwlock_wrlock(&lock)
        array.remove(at: index)
        pthread_rwlock_unlock(&lock)
    }

}

extension ThreadSafeArray: RandomAccessCollection {
    typealias Index = Int
    typealias Element = T

    var startIndex: Index {
        pthread_rwlock_rdlock(&lock)
        defer { pthread_rwlock_unlock(&lock) }
        return array.startIndex
    }

    var endIndex: Index {
        pthread_rwlock_rdlock(&lock)
        defer { pthread_rwlock_unlock(&lock) }
        return array.endIndex
    }

    func index(after i: Index) -> Index {
        pthread_rwlock_rdlock(&lock)
        defer { pthread_rwlock_unlock(&lock) }
        return array.index(after: i)
    }

    subscript(index: Int) -> T {
        get {
            pthread_rwlock_rdlock(&lock)
            defer { pthread_rwlock_unlock(&lock) }
            return array[index]
        }
        set {
            pthread_rwlock_wrlock(&lock)
            array[index] = newValue
            pthread_rwlock_unlock(&lock)
        }
    }

}
