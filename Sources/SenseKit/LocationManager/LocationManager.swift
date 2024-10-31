
import Foundation
import CoreLocation


@Observable
public class LocationManager: NSObject, CLLocationManagerDelegate {
  
  public let locationManager = CLLocationManager()
  
  public var location : DeviceLocation?
  public var heading  : Measurement<UnitAngle> = .init(value: 0, unit: .degrees)
  
  override public init() {
    super.init()
    startLocationAndHeading()
  }
  
  public func startLocationAndHeading() {
    setupLocationManager()
    locationManager.startUpdatingLocation()
    locationManager.startUpdatingHeading()
  }
  
  public func setupLocationManager() {
    locationManager.delegate = self
    requestAuthorizations()
  }
  
  public func requestAuthorizations() {
    locationManager.requestAlwaysAuthorization()
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "Pretty please?")
  }
  
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let currentLocation = locations.last else {
      return }
    self.location = DeviceLocation(fromCL: currentLocation)
  }
  
  public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    self.heading = Measurement(value: newHeading.magneticHeading.rounded(), unit: UnitAngle.degrees)
  }
}
