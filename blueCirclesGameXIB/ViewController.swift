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

    private let safePadding: CGFloat = 30
    private let areaDifferenceRatio: CGFloat = 10
    
    private var minGreen: CGFloat = 100
    private var maxGreen: CGFloat = 20
    private var differenceGreen = CGFloat()
    
    private var minBlue: CGFloat = 255
    private var maxBlue: CGFloat = 85
    private var differenceBlue = CGFloat()
    
    private var areas = [CGFloat]()
    private var minArea = CGFloat()
    private var maxArea = CGFloat()
    private var differenceArea = CGFloat()

    private var randomMaxDiameter = CGFloat()
    private var randomMinDiameter = CGFloat()
    
    private var activeCircles = [CircleView]()
    
    private var screenWitdh: CGFloat {
        return self.view.frame.width
    }
    
    private var screenHeight: CGFloat {
        return self.view.frame.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        randomMaxDiameter = screenWitdh / (CGFloat((circles.count)) * 1.15).squareRoot()
        randomMinDiameter = screenWitdh / (areaDifferenceRatio * CGFloat((circles.count))).squareRoot()
        
        var sumOfDiameters = CGFloat()
        var sumOfAreas = CGFloat()
        
        circles.forEach { (circle) in
            circle.diameter = CGFloat.random(in: randomMinDiameter ..< randomMaxDiameter)
            activeCircles.append(circle)
            sumOfDiameters += circle.diameter
            
            areas.append(circle.area)
            sumOfAreas += circle.area
        }
        
        guard let unwrappedMinArea = areas.min() else { return }
        minArea = unwrappedMinArea
        maxArea = sumOfAreas
        differenceArea = maxArea - minArea
        differenceGreen = maxGreen - minGreen
        differenceBlue = maxBlue - minBlue
         
        
        let scaleRate = (screenHeight - safePadding * 2) / sumOfDiameters
        var previuoseBottomY: CGFloat = 0
        
        activeCircles.forEach { (circle) in
            circle.setColor(to: newColor(with: circle.area))
            
            let safeAreaHeight = circle.diameter * scaleRate
             
            guard circle != circles.first else {
                previuoseBottomY = safePadding
                
                let midY = previuoseBottomY + safeAreaHeight / 2
                let minY = midY - (safeAreaHeight - circle.diameter) / 2
                let maxY = midY + (safeAreaHeight - circle.diameter) / 2
                
                circle.center.y = CGFloat.random(in: minY ..< maxY)
                circle.center.x = CGFloat.random(in: circle.radius + safePadding ..< screenWitdh - circle.radius - safePadding)
                
                previuoseBottomY += safeAreaHeight
                return
            }

            let midY = previuoseBottomY + safeAreaHeight / 2
            let minY = midY - (safeAreaHeight - circle.diameter) / 2
            let maxY = midY + (safeAreaHeight - circle.diameter) / 2
            
            circle.center.y = CGFloat.random(in: minY ..< maxY)
            circle.center.x = CGFloat.random(in: circle.radius + safePadding ..< screenWitdh - circle.radius - safePadding)
            
            previuoseBottomY += safeAreaHeight
        }
        
    }
    
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
                circle.setColor(to: newColor(with: circle.area))
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
    
    private func newColor(with area: CGFloat) -> UIColor {
        let green = minGreen + (area - minArea) / differenceArea * differenceGreen
        let blue = minBlue + (area - minArea) / differenceArea * differenceBlue
        return UIColor(red: 0/255, green: green/255, blue: blue/255, alpha: 0.9)
    }
}
