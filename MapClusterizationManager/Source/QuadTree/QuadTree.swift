import Foundation

class QuadTree: QuadNodeOutput {
    // DI
    var factory: ClusterizationFactory

    // MARK: - props

    fileprivate var clusterizedElements: [Int: [ClusterizableElement]]
    fileprivate var sizesForZooms: [Double]
    fileprivate var zooms: [Int]

    // MARK: - Life cicle

    init(factory: ClusterizationFactory,
         elements: [ClusterizableElement],
         zooms: [Int]) {
        self.factory = factory

        clusterizedElements = [:]
        sizesForZooms = []

        self.zooms = zooms

        buildTree(elements: elements)
    }

    func allClusterizedElements() -> [ClusterizableElement] {
        clusterizedElements.map { $0.value }.flatMap { $0 }
    }

    // MARK: - tree

    fileprivate func buildTree(elements: [ClusterizableElement]) {
        // prepare
        prepareForClusterizationAtZooms()

        let bounds = resizeToNearestBounds(bounds: calculateBounds(for: elements))
        let minCellSize = Double.maximum(abs(bounds.minLon - bounds.maxLon), abs(bounds.minLat - bounds.maxLat))

        guard !sizesForZooms.isEmpty else { return }
        let index = sizesForZooms.firstIndex(of: minCellSize) ?? 0

        let zoom = zooms[index]
        guard let lastZoom = zooms.last else { return }

        _ = QuadNode(elements: elements,
                     zoom: zoom,
                     lastZoom: lastZoom,
                     bounds: bounds,
                     output: self,
                     factory: factory)

        collectEmptyZooms()
    }

    fileprivate func collectEmptyZooms() {
        var elementsForLastZoom: [ClusterizableElement] = []

        for zoom in zooms.reversed() {
            if var elementsForZoom = clusterizedElements[zoom] {
                if elementsForZoom.isEmpty {
                    let cluster = factory.makeCluster(elementsForLastZoom,
                                                      zoom: zoom)

                    elementsForZoom.append(cluster)
                    clusterizedElements[zoom] = elementsForZoom
                }

                elementsForLastZoom = elementsForZoom
            }
        }
    }

    // MARK: - QuadNodeOutput

    func quadNode(didCalculateElements elements: [ClusterizableElement],
                  for zoom: Int) {
        guard zooms.contains(zoom) else { return }
        clusterizedElements[zoom]?.append(contentsOf: elements)
    }

    // MARK: - Private

    fileprivate func prepareForClusterizationAtZooms() {
        for zoom in zooms {
            sizesForZooms.append(Double(truncating: 128 / pow(2, zoom) as NSNumber))
            clusterizedElements[zoom] = []
        }
    }

    fileprivate func calculateBounds(for elements: [ClusterizableElement]) -> QuadBounds {
        let latitudes = elements.compactMap { $0.latitude }
        let longitudes = elements.compactMap { $0.longitude }

        let minLat: Double = latitudes.min() ?? 0
        let maxLat: Double = latitudes.max() ?? 0
        let minLon: Double = longitudes.min() ?? 0
        let maxLon: Double = longitudes.max() ?? 0

        return QuadBounds(minLat: minLat, maxLat: maxLat, minLon: minLon, maxLon: maxLon)
    }

    fileprivate func resizeToNearestBounds(bounds: QuadBounds) -> QuadBounds {
        let lenghtBounds = Double.maximum(abs(bounds.minLon - bounds.maxLon), abs(bounds.minLat - bounds.maxLat))
        let nearest = searchNearestZoomSize(lenghtBounds, in: sizesForZooms)
        let deltaSize = abs((nearest - lenghtBounds) / 2)

        return QuadBounds(minLat: bounds.minLat - deltaSize,
                          maxLat: bounds.maxLat + deltaSize,
                          minLon: bounds.minLon - deltaSize,
                          maxLon: bounds.maxLon + deltaSize)
    }

    fileprivate func searchNearestZoomSize(_ element: Double, in array: [Double]) -> Double {
        array.reversed().first { $0 > element } ?? array[0]
    }
}
