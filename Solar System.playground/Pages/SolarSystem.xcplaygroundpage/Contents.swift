//: Back to [Neptune](@previous)

/*:
 In this page you will explore the entire Solar System in Augmented Reality.
 
 Hit `Run My Code` to space travel.
 
 * Callout(Tips):
 You can change the universe constants to play around with the Solar System, for example, change the MULTIPLIER to a smaller number to give planets higher rotational speed.
 */

import SceneKit
import ARKit
import UIKit
import PlaygroundSupport

class SolarSystem: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    
    var sceneView = ARSCNView()
    let configuration = ARWorldTrackingConfiguration()
    
    // universe constants
    
    let ecliptic: Float = -2.0
    let SUN_POSITION = SCNVector3Make(-4, -2, -5)
    
    // Planets and stars period (in seconds)
    let SUN_ROTATION_PERIOD: Double = 24.0
    let EARTH_ROTATION_PERIOD: Double = 1.0
    let EARTH_REV_PERIOD: Double = 365.0
    let MOON_ROTATION_PERIOD: Double = 27.0
    let MOON_REV_PERIOD: Double = 27.0
    let VENUS_ROTATION_PERIOD: Double = 243.0
    let VENUS_REV_PERIOD: Double = 225.0
    let MERCURY_ROTATION_PERIOD: Double = 176.0
    let MERCURY_REV_PERIOD: Double = 88.0
    let JUPITER_ROTATION_PERIOD: Double = 0.42
    let JUPITER_REV_PERIOD: Double = 11.86 * 365
    let MARS_ROTATION_PERIOD: Double = 1.0
    let MARS_REV_PERIOD: Double = 687.0
    let SATURN_ROTATION_PERIOD: Double = 0.42
    let SATURN_REV_PERIOD: Double = 29.0 * 365
    let URANUS_ROTATION_PERIOD: Double = 0.71
    let URANUS_REV_PERIOD: Double = 84.0 * 365
    let NEPTUNE_ROTATION_PERIOD: Double = 0.67
    let NEPTUNE_REV_PERIOD: Double = 165.0 * 365
    
    // Planets and stars radius
    let SUN_RADIUS: CGFloat = 0.5
    let EARTH_RADIUS: CGFloat = 0.2
    let SUN_EARTH_RATIO: CGFloat = 109
    let SUN_VENUS_RATIO: CGFloat = 115
    let EARTH_VENUS_RATIO: CGFloat = 0.949
    let EARTH_MOON_RATIO: CGFloat = 0.25
    let EARTH_MERCURY_RATIO: CGFloat = 0.3824
    let EARTH_JUPITER_RATIO: CGFloat = 2.0
    let EARTH_MARS_RATIO: CGFloat = 0.5
    let EARTH_SATURN_RATIO: CGFloat = 2.0
    let EARTH_URANUS_RATIO: CGFloat = 1.5
    let EARTH_NEPTUNE_RATIO: CGFloat = 1.48
    
    // Distances (in meter)
    let EARTH_TO_SUN: CGFloat = 1.8
    let VENUS_TO_SUN: CGFloat = 1.1
    let MOON_TO_EARTH: CGFloat = 0.0257
    let MERCURY_TO_SUN: CGFloat = 0.5
    let JUPITER_TO_SUN: CGFloat = 3.6
    let MARS_TO_SUN: CGFloat = 2.7
    let SATURN_TO_SUN: CGFloat = 5.2
    let URANUS_TO_SUN: CGFloat = 6.7
    let NEPTUNE_TO_SUN: CGFloat = 7.7
    
    // the bigger the number, the slower the rotational speed
    let MULTIPLIER = 1.0
    
    override func loadView() {
        self.view = sceneView
        
        sceneView.antialiasingMode = SCNAntialiasingMode.multisampling4X
        sceneView.session.run(configuration)
        
        sceneView.scene.rootNode.addChildNode(createOrbitWith(SUN_RADIUS + VENUS_TO_SUN + EARTH_RADIUS * EARTH_VENUS_RATIO, andPosition: SUN_POSITION))
        sceneView.scene.rootNode.addChildNode(createOrbitWith(SUN_RADIUS + MERCURY_TO_SUN + EARTH_RADIUS * EARTH_MERCURY_RATIO, andPosition: SUN_POSITION))
        sceneView.scene.rootNode.addChildNode(createOrbitWith(SUN_RADIUS + EARTH_TO_SUN + EARTH_RADIUS, andPosition: SUN_POSITION))
        sceneView.scene.rootNode.addChildNode(createOrbitWith(SUN_RADIUS + MARS_TO_SUN + EARTH_RADIUS * EARTH_MARS_RATIO, andPosition: SUN_POSITION))
        sceneView.scene.rootNode.addChildNode(createOrbitWith(SUN_RADIUS + JUPITER_TO_SUN + EARTH_RADIUS * EARTH_JUPITER_RATIO, andPosition: SUN_POSITION))
        sceneView.scene.rootNode.addChildNode(createOrbitWith(SUN_RADIUS + SATURN_TO_SUN + EARTH_RADIUS * EARTH_SATURN_RATIO, andPosition: SUN_POSITION))
        
        // sun
        let sun = SCNNode(geometry: SCNSphere(radius: SUN_RADIUS))
        sun.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "sun.jpg")
        sun.position = SUN_POSITION
        
        // earth
        let earthParent = SCNNode()
        earthParent.position = SUN_POSITION
        let earth = planet(geometry: SCNSphere(radius: EARTH_RADIUS), diffuse: UIImage(named: "earth2.png")!, specular: UIImage(named: "earth_spec.png")!, emission: nil, normal: UIImage(named: "earth_norm.png")!, position: SCNVector3Make(Float(SUN_RADIUS + EARTH_TO_SUN + EARTH_RADIUS), 0, 0))
        
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
        
        // mars
        let marsParent = SCNNode()
        marsParent.position = SUN_POSITION
        let mars = planet(geometry: SCNSphere(radius: EARTH_RADIUS * EARTH_MARS_RATIO), diffuse: UIImage(named: "mars.jpg")!, specular: nil, emission: nil, normal: UIImage(named: "mars_norm.jpg")!, position: SCNVector3Make(Float(SUN_RADIUS + MARS_TO_SUN + EARTH_RADIUS * EARTH_MARS_RATIO), 0, 0))
        
        // jupiter
        let jupiterParent = SCNNode()
        jupiterParent.position = SUN_POSITION
        let jupiter = planet(geometry: SCNSphere(radius: EARTH_RADIUS * EARTH_JUPITER_RATIO), diffuse: UIImage(named: "jupiter.jpg")!, specular: nil, emission: nil, normal: nil, position: SCNVector3Make(Float(SUN_RADIUS + JUPITER_TO_SUN + EARTH_RADIUS * EARTH_JUPITER_RATIO), 0, 0))
        
        // saturn
        let saturnParent = SCNNode()
        saturnParent.position = SUN_POSITION
        let saturn = planet(geometry: SCNSphere(radius: EARTH_RADIUS * EARTH_SATURN_RATIO), diffuse: UIImage(named: "saturn.jpg")!, specular: nil, emission: nil, normal: nil, position: SCNVector3Make(Float(SUN_RADIUS + SATURN_TO_SUN + EARTH_RADIUS * EARTH_SATURN_RATIO), 0, 0))
        saturn.eulerAngles = SCNVector3Make(0.3, 0, 0)
        
        let ringScene = SCNScene(named: "ring.scn")!
        let ringNode = ringScene.rootNode.childNode(withName: "Circle", recursively: true)!
        ringNode.eulerAngles = SCNVector3Make(Float.pi / 2, 0, 0)
        ringNode.scale = SCNVector3Make(0.4, 0.4, 0.4)
        saturn.addChildNode(ringNode)
        
        // Uranus
        let uranusParent = SCNNode()
        uranusParent.position = SUN_POSITION
        let uranus = planet(geometry: SCNSphere(radius: EARTH_RADIUS * EARTH_URANUS_RATIO), diffuse: UIImage(named: "uranus.jpg")!, specular: nil, emission: nil, normal: nil, position: SCNVector3Make(Float(SUN_RADIUS + URANUS_TO_SUN + EARTH_RADIUS * EARTH_URANUS_RATIO), 0, 0))
        
        // neptune
        let neptuneParent = SCNNode()
        neptuneParent.position = SUN_POSITION
        let neptune = planet(geometry: SCNSphere(radius: EARTH_RADIUS * EARTH_NEPTUNE_RATIO), diffuse: UIImage(named: "neptune.jpg")!, specular: nil, emission: nil, normal: nil, position: SCNVector3Make(Float(SUN_RADIUS + NEPTUNE_TO_SUN + EARTH_RADIUS * EARTH_NEPTUNE_RATIO), 0, 0))
        
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
        sceneView.scene.rootNode.addChildNode(marsParent)
        sceneView.scene.rootNode.addChildNode(saturnParent)
        sceneView.scene.rootNode.addChildNode(uranusParent)
        sceneView.scene.rootNode.addChildNode(neptuneParent)
        earthParent.addChildNode(moonParent)
        
        moonParent.addChildNode(moon)
        earthParent.addChildNode(earth)
        venusParent.addChildNode(venus)
        mercuryParent.addChildNode(mercury)
        jupiterParent.addChildNode(jupiter)
        marsParent.addChildNode(mars)
        saturnParent.addChildNode(saturn)
        neptuneParent.addChildNode(neptune)
        uranusParent.addChildNode(uranus)
        
        let sunAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(SUN_ROTATION_PERIOD)))
        sun.runAction(sunAction)
        
        // rotation
        let earthRotation = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(EARTH_ROTATION_PERIOD * MULTIPLIER)))
        let venusRotation = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(VENUS_ROTATION_PERIOD * MULTIPLIER)))
        let moonRotation = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(MOON_ROTATION_PERIOD * MULTIPLIER)))
        let mercuryRotation = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(MERCURY_ROTATION_PERIOD * MULTIPLIER)))
        let jupiterRotation = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(JUPITER_ROTATION_PERIOD * MULTIPLIER)))
        let marsRotation = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(MARS_ROTATION_PERIOD * MULTIPLIER)))
        let saturnRotation = SCNAction.repeatForever(SCNAction.rotate(by: CGFloat.pi * 2, around: SCNVector3(0, 1, tan(0.3)), duration: SATURN_ROTATION_PERIOD))
        let uranusRotation = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(URANUS_ROTATION_PERIOD * MULTIPLIER)))
        let neptuneRotation = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(NEPTUNE_ROTATION_PERIOD * MULTIPLIER)))
        
        earth.runAction(earthRotation)
        venus.runAction(venusRotation)
        moon.runAction(moonRotation)
        mercury.runAction(mercuryRotation)
        jupiter.runAction(jupiterRotation)
        mars.runAction(marsRotation)
        saturn.runAction(saturnRotation)
        uranus.runAction(uranusRotation)
        neptune.runAction(neptuneRotation)
        
        // revolution
        let earthRevolution = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(EARTH_REV_PERIOD * MULTIPLIER)))
        let venusRevolution = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(VENUS_REV_PERIOD * MULTIPLIER)))
        let moonRevolution = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(MOON_REV_PERIOD * MULTIPLIER)))
        let mercuryRevolution = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(MERCURY_REV_PERIOD * MULTIPLIER)))
        let jupiterRevolution = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(JUPITER_REV_PERIOD * MULTIPLIER)))
        let marsRevolution = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(MARS_REV_PERIOD * MULTIPLIER)))
        let saturnRevolution = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(SATURN_REV_PERIOD * MULTIPLIER)))
        let uranusRevolution = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(URANUS_REV_PERIOD * MULTIPLIER)))
        let neptuneRevolution = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(2*Float.pi), z: 0, duration: TimeInterval(NEPTUNE_REV_PERIOD * MULTIPLIER)))
        
        earthParent.runAction(earthRevolution)
        venusParent.runAction(venusRevolution)
        moonParent.runAction(moonRevolution)
        mercuryParent.runAction(mercuryRevolution)
        jupiterParent.runAction(jupiterRevolution)
        marsParent.runAction(marsRevolution)
        saturnParent.runAction(saturnRevolution)
        uranusParent.runAction(uranusRevolution)
        neptuneParent.runAction(neptuneRevolution)
    }
    
    func createOrbitWith(_ radius: CGFloat, andPosition position: SCNVector3) -> SCNNode {
        let orbit = SCNNode(geometry: SCNTorus(ringRadius: radius, pipeRadius: 0.002))
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
