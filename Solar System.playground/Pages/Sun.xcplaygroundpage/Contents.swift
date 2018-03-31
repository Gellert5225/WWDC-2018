//: Back to [Introduction](@previous)

/*:
 In this page you will explore the characteristics of our Sun.
 
 Hit `Run My Code` to view the 3D model
 */

import UIKit
import SceneKit
import PlaygroundSupport

class SunViewController: PlanetViewController {
    var sceneView = SCNView()
    var sunScene = SunScene(with: UIColor(red: 1, green: 0xD0/255.0, blue: 0x15/255.0, alpha: 1), specular: UIColor.black, emission: UIColor(red: 1, green: 0xD0/255.0, blue: 0x15/255.0, alpha: 1), normal: UIImage(named: "Ground.png")!, size: 1, name: "Sun")
    
    var button: CornerButton!
    
    init(create: Bool) {
        super.init()
        
        self.planetName = "Sun"
        self.planet = Planet(withName: "Sun")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = sceneView
        sceneView.scene = sunScene
        sceneView.backgroundColor = UIColor.black
        
        if planetName != "Earth" {
            addButton()
            addLabels()
        }
    }
}

PlaygroundPage.current.liveView = SunViewController(create: true)
PlaygroundPage.current.needsIndefiniteExecution = true

/*:
 Go visit the [Mercury](@next)
 
 Go visit the [Solar System](SolarSystem)
 */

/*:
 ***Source code explained:***
 
 As you can see, the Sun is bursting and there are a lot of dust around it. These are accomplished by using Particle System.
 
 guard let particleSun = SCNParticleSystem(named: "sunBurst.scnp", inDirectory: "") else { return }
 sunNode.addParticleSystem(particleSun)
 
 guard let particleStars = SCNParticleSystem(named: "starDust.scnp", inDirectory: "") else { return }
 rootNode.addParticleSystem(particleStars)
 
 */
