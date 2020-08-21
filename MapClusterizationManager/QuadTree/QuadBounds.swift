import Foundation

class QuadBounds {
    var minLat: Double
    var maxLat: Double

    var minLon: Double
    var maxLon: Double

    init(minLat: Double,
         maxLat: Double,
         minLon: Double,
         maxLon: Double) {
        self.minLat = minLat
        self.maxLat = maxLat

        self.minLon = minLon
        self.maxLon = maxLon
    }
}
