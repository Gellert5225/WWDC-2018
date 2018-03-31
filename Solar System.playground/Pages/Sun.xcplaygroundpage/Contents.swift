//: Back to [Introduction](@previous)

/*:
 In this page you will explore the characteristics of our Sun.
 
 Hit `Run My Code` to view the 3D model
 */

import UIKit
import SceneKit
import PlaygroundSupport

class SunViewController: UIViewController {
    var sceneView = SCNView()
    var sunScene = SunScene(create: true) // see source file for implementation
    
    var button: CornerButton!
    
    override func loadView() {
        self.view = sceneView
        sceneView.scene = sunScene
        sceneView.backgroundColor = UIColor.black
        
        addButton()
    }
    
    func addButton() {
        button = CornerButton(withTitle: "Did You Know?")
        button.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
        
        self.view.addSubview(button)
        
        button.addButtonConstraint()
    }
    
    @objc func showDetail() {
        
    }
}

PlaygroundPage.current.liveView = SunViewController()
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
