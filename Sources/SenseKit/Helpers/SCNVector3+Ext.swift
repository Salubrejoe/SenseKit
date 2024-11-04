
import SceneKit


public extension SCNVector3 {
  var magnitude: Float {
    sqrtf(x.magnitude*x.magnitude + y.magnitude*y.magnitude + z.magnitude*z.magnitude)
  }
}
