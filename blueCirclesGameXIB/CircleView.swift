import UIKit

class CircleView: UIView {
    
    @IBOutlet private weak var xibCircleBody: UIView!
    
    var diameter: CGFloat = 100 {
        didSet {
            self.layer.zPosition = 1/diameter
            self.frame.size.width = diameter
            self.frame.size.height = diameter
            xibCircleBody.layer.cornerRadius = diameter / 2
        }
    }
    
    var radius: CGFloat {
        return diameter / 2
    }
    
    var area: CGFloat {
        return pow(diameter, 2) * CGFloat.pi / 4
    }
    
    var color: UIColor = UIColor() {
        didSet {
            self.backgroundColor = color
        }
    }
    
    private var workingView: UIView!
    private var xibName: String = "CircleView"
    
    private var absorbDistance: CGFloat {
        return radius
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCustomView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setCustomView()
    }
    
    private func getFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let xib = UINib(nibName: xibName, bundle: bundle)
        let view = xib.instantiate(withOwner: self, options: nil).first as! UIView
        view.layer.cornerRadius = diameter / 2
        return view
    }
    
    private func setCustomView() {
        workingView = getFromXib()
        workingView.frame = bounds
        workingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(workingView)
    }
    
    func canAbsorb(_ otherCircle: CircleView) -> Bool {
        let deltaX = otherCircle.center.x - self.center.x
        let deltaY = otherCircle.center.y - self.center.y
        let distanceBetweenCenters = (pow(deltaX, 2) + pow(deltaY, 2)).squareRoot()
        
        return distanceBetweenCenters <= absorbDistance
    }
    
    func absorb(_ otherCircle: CircleView, with color: UIColor) {
        let currentCenterX = self.center.x
        let currentCenterY = self.center.y
        let commonArea = otherCircle.area + area
        let newDiameter = (commonArea/CGFloat.pi).squareRoot() * 2
        otherCircle.isHidden = true
        diameter = newDiameter
        self.center.x = currentCenterX
        self.center.y = currentCenterY
        xibCircleBody.backgroundColor = color
    }
}
