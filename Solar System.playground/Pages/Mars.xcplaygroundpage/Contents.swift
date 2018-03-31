//: Back to [Earth](@previous)

/*:
 In this page you will explore the characteristics of Mars.
 
 Hit `Run My Code` to view the 3D model
 */

import UIKit
import SceneKit
import PlaygroundSupport

PlaygroundPage.current.liveView = PlanetViewController(withPlanetName: "Mars", diffuse: UIImage(named: "mars.jpg")!, specular: nil, emission: nil, normal: UIImage(named: "mars_norm.jpg"), size: 1.5)
PlaygroundPage.current.needsIndefiniteExecution = true

/*:
 Go visit the [Jupiter](@next)
 
 Go visit the [Solar System](SolarSystem)
 */
