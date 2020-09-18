import Foundation

enum QuadNodeType {
    case node
    case leaf
}

protocol QuadNodeOutput: AnyObject {
    func quadNode(didCalculateElements elements: [ClusterizableElement],
                  for zoom: Int)
}

class QuadNode {
    var type: QuadNodeType?

    var zoom: Int

    func filterElements(_ elements: [ClusterizableElement],
                        centerLon: Double,
                        centerLat: Double,
                        position: (Int, Int)) -> [ClusterizableElement] {
        elements.filter { element in
            guard let elementLon = element.longitude,
                let elementLat = element.latitude else { return false }

            switch position {
            case (-1, -1):
                return elementLon >= centerLon && elementLat < centerLat

            case (-1, 1):
                return elementLon >= centerLon && elementLat >= centerLat

            case (1, -1):
                return elementLon < centerLon && elementLat < centerLat

            case (1, 1):
                return elementLon < centerLon && elementLat >= centerLat

            default:
                return false
            }
        }
    }

    init(elements: [ClusterizableElement],
         zoom: Int,
         lastZoom: Int,
         bounds: QuadBounds,
         output: QuadNodeOutput,
         factory: ClusterizationFactory) {
        self.zoom = zoom
        guard !elements.isEmpty else { return }

        if (elements.count == 1 && lastZoom <= zoom) || lastZoom <= zoom {
            type = .leaf

        } else {
            type = .node
            let centerLat: Double = (bounds.maxLat + bounds.minLat) / 2
            let centerLon: Double = (bounds.maxLon + bounds.minLon) / 2

            // TODO: refactor

            // NEList
            let northEastSectorElements = filterElements(elements,
                                                         centerLon: centerLon,
                                                         centerLat: centerLat,
                                                         position: (1, 1))
            _ = QuadNode(elements: northEastSectorElements,
                         zoom: zoom + 1,
                         lastZoom: lastZoom,
                         bounds: QuadBounds(minLat: centerLat,
                                            maxLat: bounds.maxLat,
                                            minLon: bounds.minLon,
                                            maxLon: centerLon),
                         output: output,
                         factory: factory)

            // NWList
            let northWestSectorElements = filterElements(elements,
                                                         centerLon: centerLon,
                                                         centerLat: centerLat,
                                                         position: (1, -1))
            _ = QuadNode(elements: northWestSectorElements,
                         zoom: zoom + 1,
                         lastZoom: lastZoom,
                         bounds: QuadBounds(minLat: bounds.minLat,
                                            maxLat: centerLat,
                                            minLon: bounds.minLon,
                                            maxLon: centerLon),
                         output: output,
                         factory: factory)

            // SEList
            let southEastSectorElements = filterElements(elements,
                                                         centerLon: centerLon,
                                                         centerLat: centerLat,
                                                         position: (-1, -1))
            _ = QuadNode(elements: southEastSectorElements,
                         zoom: zoom + 1,
                         lastZoom: lastZoom,
                         bounds: QuadBounds(minLat: bounds.minLat,
                                            maxLat: centerLat,
                                            minLon: centerLon,
                                            maxLon: bounds.maxLon),
                         output: output,
                         factory: factory)

            // SWList
            let southWestSectorElements = filterElements(elements,
                                                         centerLon: centerLon,
                                                         centerLat: centerLat,
                                                         position: (-1, 1))
            _ = QuadNode(elements: southWestSectorElements,
                         zoom: zoom + 1,
                         lastZoom: lastZoom,
                         bounds: QuadBounds(minLat: centerLat,
                                            maxLat: bounds.maxLat,
                                            minLon: centerLon,
                                            maxLon: bounds.maxLon),
                         output: output,
                         factory: factory)
        }

        let elements = factory.makeClusterOrElements(elements, zoom: zoom)
        output.quadNode(didCalculateElements: elements,
                        for: zoom)
    }
}
