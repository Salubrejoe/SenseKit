import SwiftUI
import SceneKit

/// A SwiftUI view that renders a 3D vector in Cartesian coordinates using SceneKit.
public struct SKCartesianVectorView<UnitType: Dimension>: UIViewRepresentable {
  
  // MARK: - Properties
  
  /// The vector to be displayed.
  public var vector: SKVector<UnitType>
  
  /// The scale factor for the scene, allowing the vector and axis sizes to be adjusted.
  public let scale: Float
  
  /// Optional colors for the x, y, z axes and vector.
  public var axisColors: [Axis: UIColor] = [.x: .gray, .y: .gray, .z: .gray]
  public var vectorColor: UIColor = .black
  
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
  
  // MARK: - UIViewRepresentable Protocol
  
  public func makeUIView(context: Context) -> SCNView {
    let scnView = SCNView()
    scnView.backgroundColor = .clear
    scnView.scene = makeScene()
    scnView.allowsCameraControl = true
    return scnView
  }
  
  public func updateUIView(_ scnView: SCNView, context: Context) {
    // Remove the previous vector node and add an updated one if the vector changes
    scnView.scene?.rootNode.childNode(withName: "vectorNode", recursively: true)?.removeFromParentNode()
    let vectorNode = makeVectorNode(vector: vector)
    scnView.scene?.rootNode.addChildNode(vectorNode)
  }
  
  // MARK: - Scene Creation
  
  /// Creates the main 3D scene with camera, lighting, axes, and vector nodes.
  private func makeScene() -> SCNScene {
    let scene = SCNScene()
    
    // Add a camera node to the scene
    scene.rootNode.addChildNode(makeCameraNode())
    
    // Add ambient lighting to the scene
    scene.rootNode.addChildNode(makeLightNode())
    
    // Add the coordinate axes
    for axis in Axis.allCases {
      scene.rootNode.addChildNode(makeAxisNode(axis: axis))
    }
    
    // Add the vector and a center sphere for reference
    scene.rootNode.addChildNode(makeVectorNode(vector: vector))
    scene.rootNode.addChildNode(makeCenterNode())
    
    return scene
  }
  
  // MARK: - Node Creation
  
  /// Creates a camera node positioned to view the scene.
  private func makeCameraNode() -> SCNNode {
    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3(x: 0, y: 0, z: 4 * scale)
    return cameraNode
  }
  
  /// Creates an ambient light node to illuminate the scene.
  private func makeLightNode() -> SCNNode {
    let lightNode = SCNNode()
    lightNode.light = SCNLight()
    lightNode.light?.type = .ambient
    lightNode.position = SCNVector3(x: scale, y: scale, z: scale)
    return lightNode
  }
  
  /// Creates an axis node for the specified axis.
  /// - Parameter axis: The axis to create (`x`, `y`, or `z`).
  /// - Returns: A configured `SCNNode` representing the specified axis.
  private func makeAxisNode(axis: Axis) -> SCNNode {
    let axisNode = SCNNode(geometry: SCNCylinder(radius: 0.01*CGFloat(scale), height: CGFloat(scale)))
    axisNode.geometry?.firstMaterial?.diffuse.contents = axisColors[axis]
    
    let tipNode = SCNNode(geometry: SCNSphere(radius: 0.01*CGFloat(scale)))
    tipNode.geometry?.firstMaterial?.diffuse.contents = axisColors[axis]
    
    switch axis {
    case .x:
      tipNode.position = SCNVector3(scale, 0, 0)
      axisNode.position = SCNVector3(scale / 2, 0, 0)
      axisNode.eulerAngles = SCNVector3(0, 0, Float.pi / 2)
    case .y:
      tipNode.position = SCNVector3(0, scale, 0)
      axisNode.position = SCNVector3(0, scale / 2, 0)
    case .z:
      tipNode.position = SCNVector3(0, 0, scale)
      axisNode.position = SCNVector3(0, 0, scale / 2)
      axisNode.eulerAngles = SCNVector3(Float.pi / 2, 0, 0)
    }
    
    axisNode.addChildNode(tipNode)
    return axisNode
  }
  
  /// Creates a vector node based on the given vector values.
  /// - Parameter vector: The vector to create a node for.
  /// - Returns: An `SCNNode` representing the vector.
  private func makeVectorNode(vector: SKVector<UnitType>) -> SCNNode {
    let magnitude = CGFloat(vector.magnitude().value) * CGFloat(scale)
    let vectorGeometry = SCNCylinder(radius: 0.02*CGFloat(scale), height: magnitude)
    vectorGeometry.firstMaterial?.diffuse.contents = vectorColor
    
    let tipNode = SCNNode(geometry: SCNSphere(radius: 0.02*CGFloat(scale)))
    tipNode.geometry?.firstMaterial?.diffuse.contents = vectorColor
    tipNode.position = SCNVector3(0, magnitude, 0)
    
    let vectorNode = SCNNode(geometry: vectorGeometry)
    vectorNode.addChildNode(tipNode)
    vectorNode.name = "vectorNode"
    vectorNode.position = SCNVector3(0, magnitude / 2, 0)
    vectorNode.rotate(by: vector.quaternion(), aroundTarget: SCNVector3(0, 0, 0))
    
    
    
    return vectorNode
  }
  
  /// Creates a center node, which is a small sphere at the origin, for visual reference.
  private func makeCenterNode() -> SCNNode {
    let centerNode = SCNNode(geometry: SCNSphere(radius: 0.02*CGFloat(scale)))
    centerNode.geometry?.firstMaterial?.diffuse.contents = UIColor.systemBackground
    return centerNode
  }
  
  // MARK: - Axis Enum
  
  /// Enum to represent the 3D coordinate axes.
  public enum Axis: CaseIterable {
    case x, y, z
  }
}
