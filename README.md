# SenseKit

**SenseKit** is a Swift-based library designed to simplify access to various sensor data on iOS devices. Built with Core Motion and Core Location, SenseKit provides intuitive interfaces for retrieving real-time information on device activity, altitude, location, motion, and AirPods motion data. The data is returned as a Vector of Measurments with an associated Unit for easy on demand conversion.

---

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
  - [Device Activity](#device-activity)
  - [Altitude](#altitude)
  - [Location and Heading](#location-and-heading)
  - [Device Motion and Acceleration](#device-motion-and-acceleration)
  - [AirPods Motion](#airpods-motion)
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

To integrate SenseKit into your Swift project using Swift Package Manager:

1. In Xcode, go to **File > Add Packages...**
2. Enter the repository URL for SenseKit: `https://github.com/Salubrejoe/SenseKit`
3. Select the latest version and add it to your project.
### Note!
### 4. Ensure your app’s Info.plist includes the necessary permissions, such as 'Privacy - Location When In Use Usage Description' for location data and 'Privacy - Motion Usage Description'.

---

## Usage

All manager classes listed below can be accessed and handled to the enviroment thorugh the singleton `.stream`. 

eg:

```
import SenseKit

@State private var motionSensor = SKMotionSensor.stream

...

var body : some View {
  WindowGroup {
    Content View()
  }.environment(motionSensor)
}
```

Access from any view with:

```
@Environment(SKMotionSensor.self) var motionSensor
```


###SKMotionSensor 
####Properties:
- .attitude: SKVector<UnitAngle>
- .gravity: SKVector<UnitAcceleration>
- .magnetometer: SKVector<UnitMagneticField>
- .rotationRate: SKVector<UnitAngularVelocity>
- .userAcceleration: SKVector<UnitAcceleration>

###SKHeadphonesMotionSensor 
####Properties:
- .attitude: SKVector<UnitAngle>
- .gravity: SKVector<UnitAcceleration>
- .heading: SKVector<UnitAngle>
- .rotationRate: SKVector<UnitAngularVelocity>
- .userAcceleration: SKVector<UnitAcceleration>

###SKAltimeter 
####Properties:
- .pressure: Measurement<UnitPressure>?
- .absoluteAltitude: Measurement<UnitLength>?
- .absoluteAccuracy: Measurement<UnitLength>?
- .absolutePrecision: Measurement<UnitLength>?
- .relativeAltitude: Measurement<UnitLength>?

###SKLocation
####.heading:
- .trueHeading: Measurment<UnitAngle>
- .magneticHeading: Measurement<UnitAngle>
- .headingAccuracy: Measurement<UnitAngle>
####.snapshot:
- .speed: Measurement<UnitSpeed>
- .speedAccuracy: Measurement<UnitSpeed>
- .coordinates.longitude: Measurement<UnitAngle>
- .coordinates.latitude: Measurement<UnitAngle>
- .coordinates.uncertaintyRadius: Measurement<UnitLenght>
- .altitude.aboveSeaLevel: Measurement<UnitLenght>
- .altitude.ellipsoidalAltitude: Measurement<UnitLenght>
- .altitude.verticalUncertainty: Measurement<UnitLenght>

###SKActivityManager
- .currentActivity.startDate: Date
- .currentActivity.activity: SKActivity (enum)
- .currentActivity.confidence: CMMotionActivityConfidence (enum)

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

