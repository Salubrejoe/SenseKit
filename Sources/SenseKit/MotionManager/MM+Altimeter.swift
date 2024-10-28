
import CoreMotion


public extension MotionManager {
  
  func startAltimeter() throws {
    guard CMAltimeter.isRelativeAltitudeAvailable() else {
      throw MotionManagerError.altimeterUnavailable
    }
    
    altimeter
      .startRelativeAltitudeUpdates(
        to: queue,
        withHandler: updateRelativeAltitudeAndPressure
      )
    
    altimeter
      .startAbsoluteAltitudeUpdates(
        to: queue,
        withHandler: updateAbsolutAltitude
      )
    
  }
  
  private func updateRelativeAltitudeAndPressure(with altitudeData: CMAltitudeData?, error: Error?) {
    guard let altitudeData else { return }
    DispatchQueue.main.async { [weak self] in
      let pressure = altitudeData.pressure.doubleValue
      let relativeAltitude = altitudeData.relativeAltitude.doubleValue
      self?.pressure = Measurement(value: pressure, unit: .kilopascals)
      self?.relativeAltitude = Measurement(value: relativeAltitude, unit: .meters)
    }
  }
  
  private func updateAbsolutAltitude(with altitudeData: CMAbsoluteAltitudeData?, error: Error?) {
    guard let altitudeData else { return }
    DispatchQueue.main.async { [weak self] in
      let absoluteAltitude = altitudeData.altitude
      let accuracy = altitudeData.accuracy
      let precision = altitudeData.precision
      self?.absoluteAltitude = Measurement(value: absoluteAltitude, unit: .meters)
      self?.absoluteAccuracy = Measurement(value: accuracy, unit: .meters)
      self?.absolutePrecision = Measurement(value: precision, unit: .meters)
    }
  }
}
