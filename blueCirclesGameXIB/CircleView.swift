import UIKit

class CircleView: UIView {
    
    @IBOutlet private weak var xibCircleBody: UIView!
    
    private var workingView: UIView!
    private var xibName: String = "CircleView"
    
    private var radius: CGFloat = 50 {
        didSet{
            self.frame.size.width = 2 * radius
            self.frame.size.height = 2 * radius
            self.layer.zPosition += 5
            xibCircleBody.layer.cornerRadius = radius
        }
    }
    
    private var area: CGFloat {
        return pow(radius, 2) * CGFloat.pi
    }
    
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
        view.layer.cornerRadius = view.frame.size.width / 2
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
    
    func absorb(_ otherCircle: CircleView) {
        let commonArea = otherCircle.area + area
        let newRadius = (commonArea/CGFloat.pi).squareRoot()
        otherCircle.isHidden = true
        setRadius(to: newRadius)
        setBackGroundColor(with: .blue)
    }
    
    private func setRadius(to newRadius: CGFloat) {
        radius = newRadius
    }
    
    private func setBackGroundColor(with newColor: UIColor) {
        xibCircleBody.backgroundColor = newColor
    }
}
