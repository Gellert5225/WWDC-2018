import SceneKit

open class PlanetScene: SCNScene {
    
    open var planetName: String!
    
    public convenience init(with diffuse: UIImage, specular: UIImage?, emission: UIImage?, normal: UIImage?, size: CGFloat, name: String) {
        self.init()
        planetName = name
        setupCameraAndLights()
        
        let planet = SCNSphere(radius: size)
        planet.firstMaterial!.diffuse.contents = diffuse
        planet.firstMaterial!.specular.contents = specular
        planet.firstMaterial!.normal.contents = normal

        let planetNode = SCNNode(geometry: planet)
        
        let cloudMaterial = SCNMaterial()
        cloudMaterial.transparent.contents = emission
        cloudMaterial.transparencyMode = SCNTransparencyMode.rgbZero
        
        let cloudGeo = SCNSphere(radius: 1.01)
        cloudGeo.firstMaterial = cloudMaterial
        
        let cloudNode = SCNNode(geometry: cloudGeo)
        rootNode.addChildNode(cloudNode)
        
        rootNode.addChildNode(planetNode)
        
        
        if name == "Saturn" {
            // create the ring!
            planetNode.eulerAngles = SCNVector3Make(0.3, 0, 0)
            let ringScene = SCNScene(named: "ring.scn")!
            let ringNode = ringScene.rootNode.childNode(withName: "Circle", recursively: true)!
            ringNode.eulerAngles = SCNVector3Make(Float.pi / 2, 0, 0)
            planetNode.addChildNode(ringNode)
            planetNode.runAction(SCNAction.repeatForever(SCNAction.rotate(by: CGFloat.pi * 2, around: SCNVector3(0,1,tan(0.3)), duration: 6)))
        } else {
            planetNode.runAction(SCNAction.repeatForever(SCNAction.rotate(by: CGFloat.pi * 2, around: SCNVector3(0,1,0), duration: 60)))
        }
        
        guard let particleStars = SCNParticleSystem(named: "starDust.scnp", inDirectory: "") else { return }
        rootNode.addParticleSystem(particleStars)
    }
    
    open func setupCameraAndLights() {
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.usesOrthographicProjection = false
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -8)
        
        if planetName != "Saturn" {
            cameraNode.runAction(SCNAction.repeatForever(SCNAction.rotate(by: -CGFloat.pi * 2, around: SCNVector3(0,1,0), duration: 10)))
        }
        
        self.rootNode.addChildNode(cameraNode)
        
        let lightNodeSpot = SCNNode()
        lightNodeSpot.light = SCNLight()
        lightNodeSpot.light!.type = SCNLight.LightType.spot
        lightNodeSpot.position = SCNVector3(x: 30, y: 30, z: 30)
        
        let empty = SCNNode()
        empty.position = SCNVector3(x: 10, y: 4, z: 4)
        self.rootNode.addChildNode(empty)
        
        lightNodeSpot.constraints = [SCNLookAtConstraint(target: empty)]
        cameraNode.addChildNode(lightNodeSpot)
        
    }
}
