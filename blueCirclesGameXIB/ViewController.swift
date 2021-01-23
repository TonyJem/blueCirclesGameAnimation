import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var circle1: CircleView!
    @IBOutlet private weak var circle2: CircleView!
    @IBOutlet private weak var circle3: CircleView!
    @IBOutlet private weak var circle4: CircleView!
    @IBOutlet private weak var circle5: CircleView!
    @IBOutlet private weak var circle6: CircleView!
    @IBOutlet private weak var circle7: CircleView!
    @IBOutlet private var circles: [CircleView]!
    
    //    MARK: - Parameters
    private let safePadding: CGFloat = 30
    private let areaDifferenceRatio: CGFloat = 10
    private let randomMaxDiameterReducer: CGFloat = 1.15
    
    private var minGreen: CGFloat = 100
    private var maxGreen: CGFloat = 20
    private var deltaGreen = CGFloat()
    
    private var minBlue: CGFloat = 255
    private var maxBlue: CGFloat = 85
    private var deltaBlue = CGFloat()
    
    private var areas = [CGFloat]()
    private var allAreasSum = CGFloat()
    private var minArea = CGFloat()
    private var maxArea = CGFloat()
    private var differenceArea = CGFloat()
    
    private var randomMaxDiameter = CGFloat()
    private var randomMinDiameter = CGFloat()
    private var allDiametersSum = CGFloat()
    
    private var activeCircles = [CircleView]()
    
    private var screenWitdh: CGFloat {
        return self.view.frame.width
    }
    
    private var screenHeight: CGFloat {
        return self.view.frame.height
    }
    
    //    MARK: - ViewDidload
    override func viewDidLoad() {
        super.viewDidLoad()
        setCircles()
        setConstantParameters()
        setColorAndCirclePosition()
    }
    
    //    MARK: - Setup Methods
    private func setCircles() {
        randomMaxDiameter = screenWitdh / (CGFloat((circles.count)) * randomMaxDiameterReducer).squareRoot()
        randomMinDiameter = screenWitdh / (areaDifferenceRatio * CGFloat((circles.count))).squareRoot()
        
        circles.forEach { (circle) in
            circle.diameter = CGFloat.random(in: randomMinDiameter ..< randomMaxDiameter)
            allDiametersSum += circle.diameter
            allAreasSum += circle.area
            areas.append(circle.area)
            activeCircles.append(circle)
        }
    }
    
    private func setConstantParameters(){
        guard let unwrappedMinArea = areas.min() else { return }
        minArea = unwrappedMinArea
        maxArea = allAreasSum
        differenceArea = maxArea - minArea
        deltaGreen = maxGreen - minGreen
        deltaBlue = maxBlue - minBlue
    }
    
    private func setColorAndCirclePosition() {
        let scaleRate = (screenHeight - safePadding * 2) / allDiametersSum
        var topY: CGFloat = 0
        
        activeCircles.forEach { (circle) in
            circle.setColor(to: newColor(forCircleWith: circle.area))

            let minX = circle.radius + safePadding
            let maxX = screenWitdh - circle.radius - safePadding
            circle.center.x = CGFloat.random(in: minX ..< maxX)
            
            let safeAreaHeight = circle.diameter * scaleRate
            if circle == circles.first { topY = safePadding }
            let midY = topY + safeAreaHeight / 2
            let minY = midY - (safeAreaHeight - circle.diameter) / 2
            let maxY = midY + (safeAreaHeight - circle.diameter) / 2
            circle.center.y = CGFloat.random(in: minY ..< maxY)
            topY += safeAreaHeight
        }
    }
    
    //    MARK: - Actions
    @IBAction private func panCircle1Action(_ gesture: UIPanGestureRecognizer) {
        move(circle1, with: gesture)
    }
    
    @IBAction private func panCircle2Action(_ gesture: UIPanGestureRecognizer) {
        move(circle2, with: gesture)
    }
    
    @IBAction private func panCircle3Action(_ gesture: UIPanGestureRecognizer) {
        move(circle3, with: gesture)
    }
    
    @IBAction private func panCircle4Action(_ gesture: UIPanGestureRecognizer) {
        move(circle4, with: gesture)
    }
    
    @IBAction private func panCircle5Action(_ gesture: UIPanGestureRecognizer) {
        move(circle5, with: gesture)
    }
    
    @IBAction private func panCircle6Action(_ gesture: UIPanGestureRecognizer) {
        move(circle6, with: gesture)
    }
    
    @IBAction private func panCircle7Action(_ gesture: UIPanGestureRecognizer) {
        move(circle7, with: gesture)
    }
    
    private func roundCorners(for circles: [CircleView]) {
        for circle in circles {
            circle.layer.cornerRadius = circle.frame.size.width / 2
        }
    }
    
    //    MARK: - Interaction Methods
    private func move(_ movedCircle: CircleView, with gesture: UIPanGestureRecognizer) {
        let gestureTranslation = gesture.translation(in: view)
        guard let gestureView = gesture.view else { return }
        
        gestureView.center = CGPoint(
            x: gestureView.center.x + gestureTranslation.x,
            y: gestureView.center.y + gestureTranslation.y
        )
        
        gesture.setTranslation(.zero, in: view)
        guard gesture.state == .ended else { return }
        
        absorbIfCan(movedCircle)
    }
    
    private func absorbIfCan(_ movedCircle: CircleView) {
        for circle in activeCircles {
            if circle == movedCircle { continue }
            
            if circle.canAbsorb(movedCircle) {
                circle.absorb(movedCircle)
                circle.setColor(to: newColor(forCircleWith: circle.area))
                removeFromCircles(view: movedCircle)
                break
            }
        }
    }
    
    private func removeFromCircles(view: CircleView) {
        for (index, circle) in activeCircles.enumerated() {
            if circle == view {
                activeCircles.remove(at: index)
                break
            }
        }
    }
    
    private func newColor(forCircleWith area: CGFloat) -> UIColor {
        let green = minGreen + (area - minArea) / differenceArea * deltaGreen
        let blue = minBlue + (area - minArea) / differenceArea * deltaBlue
        return UIColor(red: 0/255, green: green/255, blue: blue/255, alpha: 0.9)
    }
}
