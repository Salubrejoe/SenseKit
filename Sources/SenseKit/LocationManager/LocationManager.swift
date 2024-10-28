
import Foundation
import CoreLocation


@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {
  
  public let locationManager = CLLocationManager()
  
  public var location: DeviceLocation?
  
  override init() {
    super.init()
    
    startLocationAndHeading()
  }
  
  public func startLocationAndHeading() {
    setupLocationManager()
    locationManager.startUpdatingLocation()
    locationManager.startUpdatingHeading()
  }
  
  private func setupLocationManager() {
    locationManager.delegate = self
    requestAuthorizations()
  }
  
  private func requestAuthorizations() {
    locationManager.requestAlwaysAuthorization()
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "Pretty please?")
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let currentLocation = locations.last else {
      return }
    self.location = DeviceLocation(fromCL: currentLocation)
  }
}
