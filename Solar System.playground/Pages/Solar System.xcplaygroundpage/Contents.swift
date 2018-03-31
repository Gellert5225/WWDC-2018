//: Back to [Neptune](@previous)

import SceneKit
import ARKit
import UIKit
import PlaygroundSupport

class SolarSystem: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    
    var sceneView = ARSCNView()
    let configuration = ARWorldTrackingConfiguration()
    
    // universe constants
    
    let ecliptic: Float = -2
    let SUN_POSITION = SCNVector3Make(0, -2, -5)
    
    // Planets and stars period
    let SUN_ROTATION_PERIOD: Double = 24
    let EARTH_ROTATION_PERIOD: Double = 1
    let EARTH_REV_PERIOD: Double = 365
    let MOON_ROTATION_PERIOD: Double = 27
    let MOON_REV_PERIOD: Double = 27
    let VENUS_ROTATION_PERIOD: Double = 243
    let VENUS_REV_PERIOD: Double = 225
    let MERCURY_ROTATION_PERIOD: Double = 176
    let MERCURY_REV_PERIOD: Double = 88
    let JUPITER_ROTATION_PERIOD: Double = 9.84 * 365
    let JUPITER_REV_PERIOD: Double = 11.86 * 365
    
    // Planets and stars radius
    let SUN_RADIUS: CGFloat = 0.5
    let EARTH_RADIUS: CGFloat = 0.2
    let SUN_EARTH_RATIO: CGFloat = 109
    let SUN_VENUS_RATIO: CGFloat = 115
    let EARTH_VENUS_RATIO: CGFloat = 0.949
    let EARTH_MOON_RATIO: CGFloat = 0.25
    let EARTH_MERCURY_RATIO: CGFloat = 0.3824
    let EARTH_JUPITER_RATIO: CGFloat = 2
    
    // Distances (in AU)
    let EARTH_TO_SUN: CGFloat = 1.8
    let VENUS_TO_SUN: CGFloat = 1.1
    let MOON_TO_EARTH: CGFloat = 0.0257
    let MERCURY_TO_SUN: CGFloat = 0.5
    let JUPITER_TO_SUN: CGFloat = 4
    
    // the bigger the number, the slower the rotational speed
    let MULTIPLIER = 1.0
    
    override func loadView() {
        self.view = sceneView
        
        sceneView.antialiasingMode = SCNAntialiasingMode.multisampling4X
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.session.run(configuration)
        
        sceneView.scene.rootNode.addChildNode(createOrbitWith(SUN_RADIUS + VENUS_TO_SUN + EARTH_RADIUS * EARTH_VENUS_RATIO, andPosition: SUN_POSITION))
        sceneView.scene.rootNode.addChildNode(createOrbitWith(SUN_RADIUS + MERCURY_TO_SUN + EARTH_RADIUS * EARTH_MERCURY_RATIO, andPosition: SUN_POSITION))
        sceneView.scene.rootNode.addChildNode(createOrbitWith(SUN_RADIUS + EARTH_TO_SUN + EARTH_RADIUS, andPosition: SUN_POSITION))
        sceneView.scene.rootNode.addChildNode(createOrbitWith(EARTH_RADIUS + MOON_TO_EARTH + EARTH_RADIUS * EARTH_MOON_RATIO, andPosition: SCNVector3Make(Float(SUN_RADIUS + EARTH_TO_SUN + EARTH_RADIUS), 0, 0)))
        
        // sun
        let sun = SCNNode(geometry: SCNSphere(radius: SUN_RADIUS))
        sun.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "sun.jpg")
        sun.position = SUN_POSITION
        
        // earth
        let earthParent = SCNNode()
        earthParent.position = SUN_POSITION
        let earth = planet(geometry: SCNSphere(radius: EARTH_RADIUS), diffuse: UIImage(named: "earth.jpg")!, specular: UIImage(named: "earth_spec.png")!, emission: nil, normal: UIImage(named: "earth_norm.png")!, position: SCNVector3Make(Float(SUN_RADIUS + EARTH_TO_SUN + EARTH_RADIUS), 0, 0))
        
        // moon
        let moonParent = SCNNode()
        moonParent.position = earth.position
        let moon = planet(geometry: SCNSphere(radius: EARTH_RADIUS * EARTH_MOON_RATIO), diffuse: UIImage(named: "moon.jpg")!, specular: nil, emission: nil, normal: nil, position: SCNVector3Make(Float(EARTH_RADIUS + MOON_TO_EARTH + EARTH_RADIUS * EARTH_MOON_RATIO), 0, 0))
        
        // venus
        let venusParent = SCNNode()
        venusParent.position = SUN_POSITION
        let venus = planet(geometry: SCNSphere(radius: EARTH_RADIUS * EARTH_VENUS_RATIO), diffuse: UIImage(named: "venus.jpg")!, specular: nil, emission: nil, normal: nil, position: SCNVector3Make(Float(SUN_RADIUS + VENUS_TO_SUN + EARTH_RADIUS * EARTH_VENUS_RATIO), 0, 0))
        
        // mercury
        let mercuryParent = SCNNode()
        mercuryParent.position = SUN_POSITION
        let mercury = planet(geometry: SCNSphere(radius: EARTH_RADIUS * EARTH_MERCURY_RATIO), diffuse: UIImage(named: "mercury.png")!, specular: nil, emission: nil, normal: nil, position: SCNVector3Make(Float(SUN_RADIUS + MERCURY_TO_SUN + EARTH_RADIUS * EARTH_MERCURY_RATIO), 0, 0))
        
        let jupiterParent = SCNNode()
        jupiterParent.position = SUN_POSITION
        let jupiter = planet(geometry: SCNSphere(radius: EARTH_RADIUS * EARTH_JUPITER_RATIO), diffuse: UIImage(named: "jupiter.jpg")!, specular: nil, emission: nil, normal: nil, position: SCNVector3Make(Float(SUN_RADIUS + JUPITER_TO_SUN + EARTH_RADIUS * EARTH_JUPITER_RATIO), 0, 0))
        
        let light = SCNLight()
        light.type = SCNLight.LightType.ambient
        light.color = UIColor.white
        let ambiLight = SCNNode()
        ambiLight.light = light
        ambiLight.position = SCNVector3(x: 0.2, y: 0.2, z: 0.2)
        
        //sceneView.scene.rootNode.addChildNode(ambiLight)
        sceneView.scene.rootNode.addChildNode(sun)
        sceneView.scene.rootNode.addChildNode(earthParent)
        sceneView.scene.rootNode.addChildNode(venusParent)
        sceneView.scene.rootNode.addChildNode(mercuryParent)
        sceneView.scene.rootNode.addChildNode(jupiterParent)
        earthParent.addChildNode(moonParent)
        
        let sunAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(SUN_ROTATION_PERIOD)))
        sun.runAction(sunAction)
        
        // rotation
        let earthRotation = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(EARTH_ROTATION_PERIOD * MULTIPLIER)))
        let venusRotation = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(VENUS_ROTATION_PERIOD * MULTIPLIER)))
        let moonRotation = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(MOON_ROTATION_PERIOD * MULTIPLIER)))
        let mercuryRotation = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(MERCURY_ROTATION_PERIOD * MULTIPLIER)))
        let jupiterRotation = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(JUPITER_ROTATION_PERIOD * MULTIPLIER)))
        
        earth.runAction(earthRotation)
        venus.runAction(venusRotation)
        moon.runAction(moonRotation)
        mercury.runAction(mercuryRotation)
        jupiter.runAction(jupiterRotation)
        
        // revolution
        let earthRevolution = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(EARTH_REV_PERIOD * MULTIPLIER)))
        let venusRevolution = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(VENUS_REV_PERIOD * MULTIPLIER)))
        let moonRevolution = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(MOON_REV_PERIOD * MULTIPLIER)))
        let mercuryRevolution = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(MERCURY_REV_PERIOD * MULTIPLIER)))
        let jupiterRevolution = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(JUPITER_REV_PERIOD * MULTIPLIER)))
        
        earthParent.runAction(earthRevolution)
        venusParent.runAction(venusRevolution)
        moonParent.runAction(moonRevolution)
        mercuryParent.runAction(mercuryRevolution)
        jupiterParent.runAction(jupiterRevolution)
        
        moonParent.addChildNode(moon)
        earthParent.addChildNode(earth)
        venusParent.addChildNode(venus)
        mercuryParent.addChildNode(mercury)
        jupiterParent.addChildNode(jupiter)
    }
    
    func createOrbitWith(_ radius: CGFloat, andPosition position: SCNVector3) -> SCNNode {
        let orbit = SCNNode(geometry: SCNTorus(ringRadius: radius, pipeRadius: 0.005))
        orbit.position = position
        orbit.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray
        
        return orbit
    }
    
    func planet(geometry: SCNGeometry, diffuse: UIImage, specular: UIImage?, emission: UIImage?, normal: UIImage?, position: SCNVector3) -> SCNNode {
        let planet = SCNNode(geometry: geometry)
        
        planet.geometry?.firstMaterial?.diffuse.contents = diffuse
        planet.geometry?.firstMaterial?.specular.contents = specular
        planet.geometry?.firstMaterial?.emission.contents = emission
        planet.geometry?.firstMaterial?.normal.contents = normal
        planet.position = position
        
        return planet
    }
}

PlaygroundPage.current.liveView = SolarSystem()
PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
