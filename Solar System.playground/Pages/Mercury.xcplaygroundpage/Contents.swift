//: Back to [Sun](@previous)

/*:
 In this page you will explore the characteristics of Mercury.
 
 Hit `Run My Code` to view the 3D model
 */

import UIKit
import SceneKit
import PlaygroundSupport

PlaygroundPage.current.liveView = PlanetViewController(withPlanetName: "Mercury", diffuse: UIImage(named: "mercury.png")!, specular: nil, emission: nil, normal: nil, size: 1.5)
PlaygroundPage.current.needsIndefiniteExecution = true

/*:
 Go visit the [Venus](@next)
 
 Go visit the [Solar System](SolarSystem)
 */
