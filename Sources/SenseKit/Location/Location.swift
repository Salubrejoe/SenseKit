
import CoreLocation


@Observable
public class Location: NSObject, CLLocationManagerDelegate {
  
  public let manager = CLLocationManager()
  public var snapshot : LocationSnapshot?
  public var heading          : Heading = .zero
  
  public var activityType: CLActivityType {
    manager.activityType
  }
  
  override public init() {
    super.init()
    startLocationAndHeading()
  }
  
  public func startLocationAndHeading() {
    setupLocationManager()
    manager.startUpdatingLocation()
    manager.startUpdatingHeading()
  }
  
  public func setupLocationManager() {
    manager.delegate = self
    requestAuthorizations()
  }
  
  public func requestAuthorizations() {
    manager.requestAlwaysAuthorization()
    manager.requestWhenInUseAuthorization()
    manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "Pretty please?")
  }
  
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let currentLocation = locations.last else { return }
    self.snapshot = LocationSnapshot(from: currentLocation)
  }
  
  public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    self.heading = Heading(from: newHeading)
  }
}
