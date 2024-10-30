
import CoreMotion

@Observable
public class AltitudeManager {
  public static let stream = AltitudeManager()
  
  public let altimeter = CMAltimeter()
  
  public var absoluteAltitude  : Measurement<UnitLength>?
  public var absoluteAccuracy  : Measurement<UnitLength>?
  public var absolutePrecision : Measurement<UnitLength>?
  public var relativeAltitude  : Measurement<UnitLength>?
  public var pressure          : Measurement<UnitPressure>?
  
  init() {
    do {
      try startAltimeter()
    } catch {
      handleError(AltitudeManagerError.unknownError(error))
    }
  }
  
  deinit {
    altimeter.stopAbsoluteAltitudeUpdates()
    altimeter.stopRelativeAltitudeUpdates()
  }
}

public extension AltitudeManager {
  func startAltimeter() throws {
    guard CMAltimeter.isRelativeAltitudeAvailable() else {
      throw AltitudeManagerError.relativeAltitudeNotAvailable
    }
    
    guard CMAltimeter.isAbsoluteAltitudeAvailable() else {
      throw AltitudeManagerError.absoluteAltitudeNotAvailable
    }
    
    altimeter
      .startRelativeAltitudeUpdates(
        to: .init(),
        withHandler: updateRelativeAltitudeAndPressure
      )
    
    altimeter
      .startAbsoluteAltitudeUpdates(
        to: .init(),
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
  
  func handleError(_ error: Error) {
    print("ActivityError occurred: \(error)")
  }
}

public enum AltitudeManagerError: Error {
  case relativeAltitudeNotAvailable
  case absoluteAltitudeNotAvailable
  case unknownError(Error)
}
