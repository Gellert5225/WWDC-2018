import SceneKit

public class SunScene: SCNScene {
    
    public convenience init(create:Bool) {
        self.init()
        
        setupCameraAndLights()
        
        let sun = SCNSphere(radius: 1)
        sun.firstMaterial!.diffuse.contents = UIColor(red: 1, green: 0xD0/255.0, blue: 0x15/255.0, alpha: 1)
        sun.firstMaterial!.normal.contents = UIImage(named: "Ground.png")
        sun.firstMaterial!.specular.contents = UIColor.black
        sun.firstMaterial!.emission.contents = UIColor(red: 1, green: 0xD0/255.0, blue: 0x15/255.0, alpha: 1)
        
        let sunlight = SCNLight()
        sunlight.type = SCNLight.LightType.omni
        sunlight.attenuationStartDistance = 0
        sunlight.attenuationFalloffExponent = 2
        sunlight.attenuationEndDistance = 30
        
        let sunNode = SCNNode(geometry: sun)
        sunNode.light = sunlight
        
        rootNode.addChildNode(sunNode)
        
        sunNode.runAction(SCNAction.repeatForever(SCNAction.rotate(by: CGFloat.pi * 2, around: SCNVector3(0,1,0), duration: 60)))
        
        guard let particleSun = SCNParticleSystem(named: "sunBurst.scnp", inDirectory: "") else { return }
        sunNode.addParticleSystem(particleSun)
        
        guard let particleStars = SCNParticleSystem(named: "starDust.scnp", inDirectory: "") else { return }
        rootNode.addParticleSystem(particleStars)
        
    }
    
    func setupCameraAndLights() {
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera!.usesOrthographicProjection = false
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -8)
        
        cameraNode.runAction(SCNAction.repeatForever(SCNAction.rotate(by: CGFloat.pi * 2, around: SCNVector3(0,1,0), duration: 10)))
        
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

