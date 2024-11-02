
import SwiftUI
import SceneKit


public struct AttitudeView: View {
  @Environment(MotionSensor.self) var motionSensor
  public var body: some View {
    VStack {
      VectorView(vector: motionSensor.attitude)
    }
  }
}


// The main VectorView which contains a SceneKit scene with 3D vector rendering
public struct VectorView<UnitType: Dimension>: UIViewRepresentable {
  
  public init(vector: Vector<UnitType>) {
    self.vector = vector
  }
  
//  @Binding var animate: Bool
  
  // The vector to be displayed
  public var vector: Vector<UnitType>
  
  public let scale = 1.0
  
  public func makeUIView(context: Context) -> SCNView {
    let scnView = SCNView()
    scnView.scene = makeScene()
    scnView.allowsCameraControl = true
//    scnView.autoenablesDefaultLighting = true
    return scnView
  }
  
  public func updateUIView(_ scnView: SCNView, context: Context) {
//     Update the vector in the scene when `vector` changes
    scnView.scene?.rootNode.childNode(withName: "vectorNode", recursively: true)?.removeFromParentNode()
    let vectorNode = makeVectorNode(vector: vector)
    scnView.scene?.rootNode.addChildNode(vectorNode)
  }
  
  // Creates the 3D scene with axes and vector
  private func makeScene() -> SCNScene {
    let scene = SCNScene()
    
    // Add camera
    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3(x: 0, y: 0, z: 20) // Position the camera
    scene.rootNode.addChildNode(cameraNode)
    
    // Add some lighting
    let lightNode = SCNNode()
    lightNode.light = SCNLight()
    lightNode.light?.type = .ambient
    lightNode.position = SCNVector3(x: 1, y: 1, z: 1)
    scene.rootNode.addChildNode(lightNode)
    
    // Add reference axes
    scene.rootNode.addChildNode(makeAxisNode(axis: .x))
    scene.rootNode.addChildNode(makeAxisNode(axis: .y))
    scene.rootNode.addChildNode(makeAxisNode(axis: .z))
    
    // Add initial vector
    let vectorNode = makeVectorNode(vector: vector)
    scene.rootNode.addChildNode(vectorNode)
//    scene.rootNode.addChildNode(SCNNode(geometry: SCNSphere(radius: 0.5)))
    
    return scene
  }
  
  // Creates an axis node (x, y, or z)
  private func makeAxisNode(axis: Axis) -> SCNNode {
    
    let axisNode = SCNNode()
    axisNode.geometry = SCNCylinder(radius: 0.1, height: scale)
    
    switch axis {
    case .x:
      axisNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
      axisNode.position = SCNVector3(scale/2, 0, 0)
      axisNode.eulerAngles = SCNVector3(0, 0, Float.pi / 2)
    case .y:
      axisNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
      axisNode.position = SCNVector3(0, scale/2, 0)
    case .z:
      axisNode.geometry?.firstMaterial?.diffuse.contents = UIColor.green
      axisNode.position = SCNVector3(0, 0, scale/2)
      axisNode.eulerAngles = SCNVector3(Float.pi / 2, 0, 0)
    }
    
    return axisNode
  }
  
  // Creates a vector node based on the given vector values
  private func makeVectorNode(vector: Vector<UnitType>) -> SCNNode {
    let magnitude = CGFloat(vector.magnitude().value)*10
    
    let vectorGeometry = SCNCylinder(radius: 0.2, height: magnitude)
    vectorGeometry.firstMaterial?.diffuse.contents = UIColor.black
    let vectorNode = SCNNode(geometry: vectorGeometry)
    vectorNode.name = "vectorNode"
    vectorNode.position = SCNVector3(0, magnitude/2, 0)
    vectorNode.rotate(by: vector.quaternion(), aroundTarget: SCNVector3(0, 0, 0))
    
    // Orient the node towards the vector direction
//    vectorNode.look(at: SCNVector3(components.x, -components.y, components.z))
//    vectorNode.localTranslate(by: SCNVector3(10, 10, 10))
    
    return vectorNode
  }
  
  // Axis enum to simplify axis handling
  private enum Axis {
    case x, y, z
  }
}


public extension SCNVector3 {
  var magnitude: Float {
    sqrtf(x.magnitude*x.magnitude + y.magnitude*y.magnitude + z.magnitude*z.magnitude)
  }
}

public extension Vector  {
  
  /// Calculates a quaternion to represent the orientation of the vector relative to the x-axis
  func quaternion(relativeTo reference: SCNVector3 = SCNVector3(0,1,0)) -> SCNQuaternion {
    
    let scnVector = SCNVector3(self.x.value, self.y.value, self.z.value)
    
    // Normalize the vectors
    let vMagnitude = scnVector.magnitude
    let rMagnitude = reference.magnitude
    
    let normalizedV = SCNVector3(
      scnVector.x / vMagnitude,
      scnVector.y / vMagnitude,
      scnVector.z / vMagnitude
    )
    
    let normalizedR = SCNVector3(
      reference.x / rMagnitude,
      reference.y / rMagnitude,
      reference.z / rMagnitude
    )
    
    
    // Calculate the dot product and angle
    let dotProduct = normalizedV.x * normalizedR.x +
    normalizedV.y * normalizedR.y +
    normalizedV.z * normalizedR.z
    let angle = acos(dotProduct)
    
    // Calculate the axis of rotation (cross product)
    let axisX = normalizedV.y * normalizedR.z - normalizedV.z * normalizedR.y
    let axisY = normalizedV.z * normalizedR.x - normalizedV.x * normalizedR.z
    let axisZ = normalizedV.x * normalizedR.y - normalizedV.y * normalizedR.x
    
    // Normalize the axis vector
    let axisMagnitude = sqrt(axisX * axisX + axisY * axisY + axisZ * axisZ)
    let unitAxisX = axisX / axisMagnitude
    let unitAxisY = axisY / axisMagnitude
    let unitAxisZ = axisZ / axisMagnitude
    
    // Calculate quaternion components
    let halfAngleSin = sin(angle / 2)
    let qx = unitAxisX * halfAngleSin
    let qy = unitAxisY * halfAngleSin
    let qz = unitAxisZ * halfAngleSin
    let qw = cos(angle / 2)
    
    return SCNQuaternion(qx, qy, qz, -qw)
  }
}
