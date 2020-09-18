import CoreLocation
import Foundation

public protocol ClusterizableElement {
    var coordinate: CLLocationCoordinate2D? { get }
}

public extension ClusterizableElement {
    var latitude: Double? {
        coordinate?.latitude
    }

    var longitude: Double? {
        coordinate?.longitude
    }
}
