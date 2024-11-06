import CoreMotion

/// `SKAltimeter` is a singleton class responsible for monitoring the device's altitude data.
/// It uses `CMAltimeter` to obtain both relative and absolute altitude information, along with pressure data.
/// Altitude readings are available only on devices that support altimeter sensors.
@MainActor
@Observable
public class SKAltimeter {
  public static let stream = SKAltimeter()
  
  /// `CMAltimeter` instance to track altitude changes.
  public let altimeter = CMAltimeter()
  
  /// The absolute altitude, if available, measured in meters.
  public var absoluteAltitude: Measurement<UnitLength>?
  
  /// The accuracy of the absolute altitude, measured in meters.
  public var absoluteAccuracy: Measurement<UnitLength>?
  
  /// The precision of the absolute altitude, measured in meters.
  public var absolutePrecision: Measurement<UnitLength>?
  
  /// The relative altitude since the start of the app session, measured in meters.
  public var relativeAltitude: Measurement<UnitLength>?
  
  /// The air pressure at the current altitude, measured in kilopascals.
  public var pressure: Measurement<UnitPressure>?
  
  /// Initializes the `SKAltimeter` and starts altitude monitoring if available.
  init() {
    do {
      try startAltimeter()
    } catch {
      handleError(SKAltimeterError.unknownError(error))
    }
  }
  
  /// Stops altitude updates when the instance is deinitialized.
  public func stop() {
    altimeter.stopAbsoluteAltitudeUpdates()
    altimeter.stopRelativeAltitudeUpdates()
  }
}

public extension SKAltimeter {
  
  /// Starts monitoring for both relative and absolute altitude updates.
  /// - Throws: `SKAltimeterError` if relative or absolute altitude is unavailable.
  func startAltimeter() throws {
    guard CMAltimeter.isRelativeAltitudeAvailable() else {
      throw SKAltimeterError.relativeAltitudeNotAvailable
    }
    
    guard CMAltimeter.isAbsoluteAltitudeAvailable() else {
      throw SKAltimeterError.absoluteAltitudeNotAvailable
    }
    
    altimeter.startRelativeAltitudeUpdates(
      to: .main,
      withHandler: updateRelativeAltitudeAndPressure
    )
    
    altimeter.startAbsoluteAltitudeUpdates(
      to: .main,
      withHandler: updateAbsoluteAltitude
    )
  }
  
  /// Updates the `relativeAltitude` and `pressure` properties using data from `CMAltitudeData`.
  private func updateRelativeAltitudeAndPressure(with altitudeData: CMAltitudeData?, error: Error?) {
    guard let altitudeData else { return }
    DispatchQueue.main.async { [weak self] in
      self?.pressure = Measurement(value: altitudeData.pressure.doubleValue, unit: .kilopascals)
      self?.relativeAltitude = Measurement(value: altitudeData.relativeAltitude.doubleValue, unit: .meters)
    }
  }
  
  /// Updates the `absoluteAltitude`, `absoluteAccuracy`, and `absolutePrecision` properties using data from `CMAbsoluteAltitudeData`.
  private func updateAbsoluteAltitude(with altitudeData: CMAbsoluteAltitudeData?, error: Error?) {
    guard let altitudeData else { return }
    DispatchQueue.main.async { [weak self] in
      self?.absoluteAltitude = Measurement(value: altitudeData.altitude, unit: .meters)
      self?.absoluteAccuracy = Measurement(value: altitudeData.accuracy, unit: .meters)
      self?.absolutePrecision = Measurement(value: altitudeData.precision, unit: .meters)
    }
  }
  
  /// Logs errors that occur during altitude data updates.
  /// - Parameter error: The error encountered in `AltitudeManager`.
  func handleError(_ error: Error) {
    print("AltitudeManager error occurred: \(error)")
  }
}

// MARK: - AltitudeManagerError

/// Enum defining errors for `SKAltimeter`.
public enum SKAltimeterError: Error {
  /// Error indicating that relative altitude monitoring is unavailable.
  case relativeAltitudeNotAvailable
  
  /// Error indicating that absolute altitude monitoring is unavailable.
  case absoluteAltitudeNotAvailable
  
  /// Error indicating an unknown error, with an associated error object.
  case unknownError(Error)
}
