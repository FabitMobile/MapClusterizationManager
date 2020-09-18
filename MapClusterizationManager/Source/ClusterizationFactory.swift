import Foundation

public protocol ClusterizationFactory {
    func makeClusterOrElements(_ elements: [ClusterizableElement],
                               zoom: Int) -> [ClusterizableElement]
    func makeCluster(_ elements: [ClusterizableElement],
                     zoom: Int) -> ClusterizableElement
}
