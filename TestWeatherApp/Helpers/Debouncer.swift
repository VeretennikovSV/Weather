import Foundation

final class Debouncer {
    private var queue = DispatchQueue.main
    private var action: (() -> Void)?
    private var workItem: DispatchWorkItem?

    init(queue: Dispatch.DispatchQueue = DispatchQueue.main) {
        self.queue = queue
    }

    func debounce(timeout: TimeInterval, action: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem(block: action)
        guard let workItem else { return }
        queue.asyncAfter(deadline: .now() + timeout, execute: workItem)
    }
}
