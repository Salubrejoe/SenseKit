# SenseKit

**SenseKit** is a Swift-based library designed to simplify access to various sensor data on iOS devices. Built with Core Motion and Core Location, SenseKit provides intuitive interfaces for retrieving real-time information on device activity, altitude, location, motion, and AirPods motion data. The data is returned as a Vector of Measurments with an associated Unit for easy on demand conversion.

---

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Test](#test)
- [Usage](#usage)
  - [DeviceMotion](#skmotionsensor)
  - [Altitude](#skaltimeter)
  - [Location](#sklocation)
- [Requirements](#requirements)
- [License](#license)

---

## Features

SenseKit is organized into several singleton classes that each manage a specific type of sensor data:

1. **SKMotionSensor**: Accesses motion and environmental metrics, including acceleration, gravity, attitude, rotation rate, and magnetometer readings.
2. **SKActivityManager**: Accesses device activity information such as walking, running, and driving.
3. **SKAltimeter**: Retrieves altitude and pressure data using the device’s altimeter.
4. **SKHeadphonesMotionSensor**: Provides motion data from motion-enabled AirPods.
5. **SKLocation**: Supplies location and heading updates. 

---

## Installation
### Note!
Ensure your app’s `Info.plist` includes the necessary permissions, such as 'Privacy - Location When In Use Usage Description' for location data and 'Privacy - Motion Usage Description'.

To integrate SenseKit into your Swift project using Swift Package Manager:

1. In Xcode, go to **File > Add Packages...**
2. Enter the repository URL for SenseKit: `https://github.com/Salubrejoe/SenseKit`
3. Select the latest version and add it to your project.

---

## Test

Try out all of the available data with the integrated test views:

1.  `SensorsTestTabView()`
```
public struct SensorsTestTabView: View {
  public var body: some View {
    TabView {
      MotionSensorTestForm()
      AltitudeTestForm()
      LocationTestForm()
      ActivityTestForm()
    }
  }
}
```

2. `SKCartesianVectorView(vector: SKVector)`
```
public struct SKCartesianVectorView<UnitType: Dimension>: UIViewRepresentable {
  
  // MARK: - Properties
  
  /// The vector to be displayed.
  public var vector: SKVector<UnitType>
  
  /// The scale factor for the scene, allowing the vector and axis sizes to be adjusted.
  public let scale: Float
  
  /// Optional colors for the x, y, z axes and vector.
  public var axisColors: [Axis: UIColor] = [.x: .secondaryLabel, .y: .secondaryLabel, .z: .secondaryLabel]
  public var vectorColor: UIColor = .label
  
  // MARK: - Initializer
  
  /// Initializes the `CartesianVectorView` with a vector and optional parameters.
  /// - Parameters:
  ///   - vector: The 3D vector to be rendered.
  ///   - scale: The scale factor for the scene.
  ///   - axisColors: A dictionary of colors for the x, y, and z axes.
  ///   - vectorColor: The color of the vector.
  public init(
    for vector: SKVector<UnitType>,
    scale: Float = 1.0,
    axisColors: [Axis: UIColor]? = nil,
    vectorColor: UIColor = .systemPink
  ) {
    self.vector = vector
    self.scale = scale
    self.axisColors = axisColors ?? self.axisColors
    self.vectorColor = vectorColor
  }
```

(Remember to update `Info.plist`)

---

## Usage

All manager classes listed below can be accessed and handled to the enviroment thorugh the singleton `.stream`. 

Example:

```
import SwiftUI
import SenseKit

@main
struct YourAppsNameApp: App {
  @State private var motion           = SKMotionSensor.stream
  @State private var location         = SKLocation.stream
  @State private var barimeter        = SKAltimeter.stream
  @State private var activityManager  = SKActivityManager.stream
  
  var body: some Scene {
    WindowGroup {
      ContentView()

    }
    .environment(motion)
    .environment(location)
    .environment(barimeter)
    .environment(activityManager)
  }
}
```

Access from any view with:

```
@Environment(SKMotionSensor.self) var motionSensor
@Environment(SKLocation.self) var location
@Environment(SKAltimeter.self) var barimeter
@Environment(SKActivityManager.self) var activityManager
```


### SKMotionSensor 
#### Properties:
- `.attitude: SKVector<UnitAngle>`
- `.gravity: SKVector<UnitAcceleration>`
- `.magnetometer: SKVector<UnitMagneticField>`
- `.rotationRate: SKVector<UnitAngularVelocity>`
- `.userAcceleration: SKVector<UnitAcceleration>`

### SKHeadphonesMotionSensor 
#### Properties:
- `.attitude: SKVector<UnitAngle>`
- `.gravity: SKVector<UnitAcceleration>`
- `.heading: SKVector<UnitAngle>`
- `.rotationRate: SKVector<UnitAngularVelocity>`
- `.userAcceleration: SKVector<UnitAcceleration>`

### SKAltimeter 
#### Properties:
- `.pressure: Measurement<UnitPressure>?`
- `.absoluteAltitude: Measurement<UnitLength>?`
- `.absoluteAccuracy: Measurement<UnitLength>?`
- `.absolutePrecision: Measurement<UnitLength>?`
- `.relativeAltitude: Measurement<UnitLength>?`

### SKLocation
#### .heading:
- `.trueHeading: Measurment<UnitAngle>`
- `.magneticHeading: Measurement<UnitAngle>`
- `.headingAccuracy: Measurement<UnitAngle>`
#### .snapshot:
- `.speed: Measurement<UnitSpeed>`
- `.speedAccuracy: Measurement<UnitSpeed>`
- `.coordinates.longitude: Measurement<UnitAngle>`
- `.coordinates.latitude: Measurement<UnitAngle>`
- `.coordinates.uncertaintyRadius: Measurement<UnitLenght>`
- `.altitude.aboveSeaLevel: Measurement<UnitLenght>`
- `.altitude.ellipsoidalAltitude: Measurement<UnitLenght>`
- `.altitude.verticalUncertainty: Measurement<UnitLenght>`

### SKActivityManager
- `.currentActivity.startDate: Date`
- `.currentActivity.activity: SKActivity (enum)`
- `.currentActivity.confidence: CMMotionActivityConfidence (enum)`

---

## View Modifiers

This first version supports 3 Custom View Modifiers:

### .skAttitudeModifier
- `pitchFactor` multiplies the pitch angle
- `rollFactor` multiplies the roll angle
- `animation` allows you to pick your animation
- `normaliser` accepts a function that will edit the angle. (acts BEFORE the pitchFactor/rollFactor)

### .skCompassModifier
- `initialDisplacement` in `SwiftUI.Angle`

### .skAttitudeModifier
- `offsetAt1G` is the offset value when acceleration hits 1 G of force.
- `animation` allows you to pick your animation
- `normaliser` accepts a function that will edit the offset. (acts AFTER the offsetAt1G multiplier)

---

## Requirements

- iOS 18.0 or later
- Devices with relevant hardware support:
Altimeter data requires a barometer-equipped device.
AirPods motion data requires compatible AirPods.

---

## License

SenseKit is available under the MIT license. 

---

