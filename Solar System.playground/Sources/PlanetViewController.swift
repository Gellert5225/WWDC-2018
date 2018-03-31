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
    
    var shouldShowDetail = true
    
    public init(withPlanetName name: String, diffuse: UIImage, specular: UIImage?, emission: UIImage?, normal: UIImage?, size: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        
        planetScene = PlanetScene(with: diffuse, specular: specular, emission: emission, normal: normal, size: size, name: name)
        planetName = name
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
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        titleLabel.text = planetName
        
        massLabel.text = "ASDASD"
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(massLabel)
        self.view.addSubview(diameterLabel)
        self.view.addSubview(distanceLabel)
        self.view.addSubview(factLabel)
        
        addLabelConstraints()
    }
    
    func addLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        massLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabelTopConstraint = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 20)
        
        //let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 10)
        
        let titleLabelCenter = NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        
        let massLabelTopConstraint = NSLayoutConstraint(item: massLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 20)
        let massLabelCenter = NSLayoutConstraint(item: massLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([titleLabelTopConstraint, titleLabelCenter, massLabelCenter, massLabelTopConstraint])
    }
    
    override public func loadView() {
        self.view = sceneView
        sceneView.scene = planetScene
        sceneView.backgroundColor = UIColor.black
        
        addButton()
        addLabels()
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
    }
    
    @objc func showDetail() {
        shouldShowDetail = !shouldShowDetail
        updateView()
    }
}
