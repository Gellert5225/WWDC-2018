import SceneKit

public class SunScene: PlanetScene {
    
    public convenience init(with diffuse: UIColor, specular: UIColor, emission: UIColor, normal: UIImage, size: CGFloat, name: String) {
        self.init()
        
        self.planetName = name
        
        setupCameraAndLights()
        
        let sun = SCNSphere(radius: size)
        sun.firstMaterial!.diffuse.contents = diffuse
        sun.firstMaterial!.normal.contents = normal
        sun.firstMaterial!.specular.contents = specular
        sun.firstMaterial!.emission.contents = emission
        
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
}

