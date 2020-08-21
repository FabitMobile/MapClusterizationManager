import Foundation

public class QuadTreeManager: ClusterizationManager {
    // MARK: - DI

    var factory: ClusterizationFactory

    // MARK: - props

    public init(factory: ClusterizationFactory) {
        self.factory = factory
    }

    // MARK: - ClusterizationManager

    public func clusterize(elements: [ClusterizableElement],
                           forZooms zooms: [Int],
                           completion: ClusterizationManagerСompletion?) {
        let tree = QuadTree(factory: factory,
                            elements: elements,
                            zooms: zooms)
        let result = tree.allClusterizedElements()

        if let completion = completion {
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
