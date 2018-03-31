import UIKit
import SceneKit
import PlaygroundSupport

public class PlanetViewController: UIViewController {
    var sceneView = SCNView()
    var planetScene: PlanetScene!
    var button: CornerButton!
    var planetName: String!
    
    var titleLabel: DetailLabel!
    var massLabel: DetailLabel!
    var diameterLabel: DetailLabel!
    var distanceLabel: DetailLabel!
    var factLabel: DetailLabel!
    var factDetailLabel: DetailLabel!
    
    var shouldShowDetail = true
    
    var planet: Planet?
    
    public init(withPlanetName name: String, diffuse: UIImage, specular: UIImage?, emission: UIImage?, normal: UIImage?, size: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        
        planetScene = PlanetScene(with: diffuse, specular: specular, emission: emission, normal: normal, size: size, name: name)
        planetName = name
        
        planet = Planet(withName: planetName)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLabels() {
        titleLabel = DetailLabel()
        massLabel = DetailLabel()
        diameterLabel = DetailLabel()
        distanceLabel = DetailLabel()
        factLabel = DetailLabel()
        factDetailLabel = DetailLabel()
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.text = planetName
        
        massLabel.text = "Mass: " + planet!.mass!
        diameterLabel.text = "Diameter: " + planet!.diameter!
        distanceLabel.text = "Distance: " + planet!.distance!
        factLabel.text = "Fun Fact: "
        factDetailLabel.text = planet!.fact!
        factDetailLabel.textAlignment = NSTextAlignment.center;
        factDetailLabel.numberOfLines = 0;
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(massLabel)
        self.view.addSubview(diameterLabel)
        self.view.addSubview(distanceLabel)
        self.view.addSubview(factLabel)
        self.view.addSubview(factDetailLabel)
        
        addLabelConstraints()
    }
    
    func addLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        massLabel.translatesAutoresizingMaskIntoConstraints = false
        diameterLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        factDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        factLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabelTopConstraint = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 20)
        let titleLabelCenter = NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        
        let massLabelTopConstraint = NSLayoutConstraint(item: massLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 20)
        let massLabelCenter = NSLayoutConstraint(item: massLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        
        let diameterLabelTopConstraint = NSLayoutConstraint(item: diameterLabel, attribute: .top, relatedBy: .equal, toItem: massLabel, attribute: .bottom, multiplier: 1, constant: 20)
        let diameterLabelCenter = NSLayoutConstraint(item: diameterLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        
        let distanceLabelTopConstraint = NSLayoutConstraint(item: distanceLabel, attribute: .top, relatedBy: .equal, toItem: diameterLabel, attribute: .bottom, multiplier: 1, constant: 20)
        let distanceLabelCenter = NSLayoutConstraint(item: distanceLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        
        let factLabelTopConstraint = NSLayoutConstraint(item: factLabel, attribute: .top, relatedBy: .equal, toItem: distanceLabel, attribute: .bottom, multiplier: 1, constant: 20)
        let factLabelCenter = NSLayoutConstraint(item: factLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        
        let factDetailLabelTopConstraint = NSLayoutConstraint(item: factDetailLabel, attribute: .top, relatedBy: .equal, toItem: factLabel, attribute: .bottom, multiplier: 1, constant: 10)
        let factDetailLabelCenter = NSLayoutConstraint(item: factDetailLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let factDetailLabelWidth = NSLayoutConstraint(item: factDetailLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        
        NSLayoutConstraint.activate([titleLabelTopConstraint, titleLabelCenter, massLabelCenter, massLabelTopConstraint, diameterLabelTopConstraint, diameterLabelCenter, distanceLabelCenter, distanceLabelTopConstraint, factDetailLabelCenter, factDetailLabelTopConstraint, factLabelCenter, factLabelTopConstraint, factDetailLabelWidth])
    }
    
    override public func loadView() {
        self.view = sceneView
        sceneView.scene = planetScene
        sceneView.backgroundColor = UIColor.black
        
        if planetName != "Earth" {
            addButton()
            addLabels()
        }
    }
    
    func addButton() {
        button = CornerButton(withTitle: "Did You Know?")
        button.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
        
        self.view.addSubview(button)
        
        button.addButtonConstraint()
    }
    
    func updateView() {
        button.setTitle(shouldShowDetail ? "Did You Know?" : "Close", for: .normal)
        titleLabel.isHidden = shouldShowDetail
        massLabel.isHidden = shouldShowDetail
        diameterLabel.isHidden = shouldShowDetail
        distanceLabel.isHidden = shouldShowDetail
        factLabel.isHidden = shouldShowDetail
        factDetailLabel.isHidden = shouldShowDetail
    }
    
    @objc func showDetail() {
        shouldShowDetail = !shouldShowDetail
        updateView()
    }
}

struct Planet {
    var name: String!
    var mass: String!
    var diameter: String!
    var distance: String!
    var fact: String!
    
    init(withName name: String) {
        let url = Bundle.main.url(forResource: "planets", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            if let dictionary = object as? [AnyObject] {
                readJSONObject(object: dictionary, withName: name)
            }
        } catch {
            // Handle Error
        }
    }
    
    mutating func readJSONObject(object: [AnyObject], withName name: String) {
        for a in object {
            if (a.value(forKey: "name")! as! String == name) {
                self.name = name
                self.mass = a.value(forKey: "mass") as! String
                self.diameter = a.value(forKey: "diameter") as! String
                self.distance = a.value(forKey: "distancetoearth") as! String
                self.fact = a.value(forKey: "funfacts") as! String
            }
        }
    }
}
