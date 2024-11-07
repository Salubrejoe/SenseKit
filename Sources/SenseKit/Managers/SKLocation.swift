import CoreLocation

/// A singleton class that provides location and heading updates using `CLLocationManager`.
@Observable
public class SKLocation: NSObject, CLLocationManagerDelegate, @unchecked Sendable {
  
  /// A shared instance of the `Location` class.
  @MainActor
  public static let stream = SKLocation()
  
  /// The location manager that handles location and heading updates.
  public let manager = CLLocationManager()
  
  /// A snapshot of the current location.
  public var snapshot: SKLocationSnapshot?
  
  /// The current heading of the device.
  public var heading: SKLocationHeading = .init()
  
  /// The activity type for the location manager, indicating how location data is used.
  public var activityType: CLActivityType {
    manager.activityType
  }
  
  /// Initializes the location manager and starts updating location and heading.
  override public init() {
    super.init()
    startLocationAndHeading()
  }
  
  /// Starts location and heading updates.
  public func startLocationAndHeading() {
    setupLocationManager()
    manager.startUpdatingLocation()
    manager.startUpdatingHeading()
  }
  
  /// Configures the location manager settings and requests necessary authorizations.
  public func setupLocationManager() {
    manager.delegate = self
    manager.activityType = .fitness
    requestAuthorizations()
  }
  
  /// Requests authorization for location services.
  public func requestAuthorizations() {
    manager.requestWhenInUseAuthorization()
  }
  
  public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      startLocationAndHeading()
    case .denied, .restricted:
      print("Location access denied or restricted.")
    case .notDetermined:
      requestAuthorizations()
    @unknown default:
      break
    }
  }
  
  /// Delegate method that is called when new location data is available.
  /// - Parameter manager: The location manager object that is sending the update.
  /// - Parameter locations: An array of locations that have been updated.
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let currentLocation = locations.last else { return }
    let currentLocationCopy = SKLocationSnapshot(from: currentLocation)
    DispatchQueue.main.async {
      self.snapshot = currentLocationCopy
    }
  }
  
  /// Delegate method that is called when the heading is updated.
  /// - Parameter manager: The location manager object that is sending the update.
  /// - Parameter newHeading: The new heading data.
  
  public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    let headingCopy = SKLocationHeading(from: newHeading)
    DispatchQueue.main.async {
      self.heading = headingCopy
    }
  }
}
