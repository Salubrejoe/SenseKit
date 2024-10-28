
import Foundation
import CoreMotion


@Observable
final class MotionManager: NSObject, CLLocationManagerDelegate {
  public static let stream = MotionManager()
   
  public let updateInterval = 0.2
  
  public let queue     = OperationQueue()
  public let mainQueue = OperationQueue.main
  
  // - CMMotionManager
  public let motion          = CMMotionManager()
  public let headphoneMotion = CMHeadphoneMotionManager()
  /// DEVICE MOTION
  public var attitude         : Vector<UnitAngle>?
  public var rotationRate     : Vector<UnitAngularVelocity>?
  public var gravity          : Vector<UnitAcceleration>?
  public var userAcceleration : Vector<UnitAcceleration>?
  public var heading          : Measurement<UnitAngle>?
  /// MAGNETOMETER
  public var magnetometer  : Vector<UnitMagneticField>?
  
  // - ACTIVITY
  public let activityManager = CMMotionActivityManager()
  public var activity      : CMMotionActivity?
  
  // - ALTIMETER
  public let altimeter         = CMAltimeter()
  public var absoluteAltitude  : Measurement<UnitLength>?
  public var absoluteAccuracy  : Measurement<UnitLength>?
  public var absolutePrecision : Measurement<UnitLength>?
  public var relativeAltitude  : Measurement<UnitLength>?
  public var pressure          : Measurement<UnitPressure>?
   
  public var coreMode = CoreMotionMode.phone
  
  override init() {
    super.init()
    
    do {
      try start()
    } catch {
      handleError(MotionManagerError.unknownError(error))
    }
  }
  
  deinit { stop() }
  
  public func start() throws {
    
    stop()
    
    try startActivityUpdates()
    try startAltimeter()
    try startMagnetometer()
    
    switch coreMode {
      
    case .phone:
      try startDeviceMotion()
      
    case .headPhones:
      
      try startHeadphonesDeviceMotion()
    }
  }
  
  public func stop() {
    
    motion.stopMagnetometerUpdates()
    motion.stopDeviceMotionUpdates()
    headphoneMotion.stopDeviceMotionUpdates()
    
    activityManager.stopActivityUpdates()

    altimeter.stopRelativeAltitudeUpdates()
    altimeter.stopAbsoluteAltitudeUpdates()
  }
}
