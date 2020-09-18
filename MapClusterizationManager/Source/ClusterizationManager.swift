import Foundation

public typealias ClusterizationManagerСompletion = (_ result: [ClusterizableElement]) -> Void
// sourcery: mirageMock
public protocol ClusterizationManager {
    func clusterize(elements: [ClusterizableElement],
                    forZooms zooms: [Int],
                    completion: ClusterizationManagerСompletion?)
}
