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
    
    // MARK: - Screen parameters
    private let areaDifferenceRatio: CGFloat = 10
    
    private let minHue: CGFloat = 0.63
    private let maxHue: CGFloat = 0.58
    private var hueDifference = CGFloat()

    private let minBrightness: CGFloat = 0.5
    private let maxBrightness: CGFloat = 1
    private var brightnessDifference = CGFloat()
    
    private var startingColor = UIColor()
    
    private var minDiameter = CGFloat()
    private var maxDiameter = CGFloat()
    private var diamDeference = CGFloat()
    var sumOfDiameters = CGFloat()
    
    private var sumOfAreas = CGFloat()
    private var minArea = CGFloat()
    private var areaDeference = CGFloat()
    
    
    private var screenWitdh = CGFloat()
    private var screenHeight = CGFloat()
    private var randomMaxDiameter = CGFloat()
    private var randomMinDiameter = CGFloat()
    
    var activeCircles = [CircleView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startingColor = UIColor(hue: maxHue, saturation: 1, brightness: maxBrightness, alpha: 0.9)
        
        screenWitdh = self.view.frame.width
        screenHeight = self.view.frame.height
                
        randomMaxDiameter = screenWitdh / (CGFloat((circles.count)) * 1.15).squareRoot()
        randomMinDiameter = screenWitdh / (areaDifferenceRatio * CGFloat((circles.count))).squareRoot()
        
        var diameteres = [CGFloat]()
        var areas = [CGFloat]()
        
        circles.forEach { (circle) in
            circle.diameter = CGFloat.random(in: randomMinDiameter ..< randomMaxDiameter)
            circle.color = startingColor
            activeCircles.append(circle)
            sumOfDiameters += circle.diameter
            sumOfAreas += circle.area
            diameteres.append(circle.diameter)
            areas.append(circle.area)
        }
        
        minDiameter = diameteres.min()!
        maxDiameter = diameteres.max()!
        
        minArea = areas.min()!
        
        areaDeference = sumOfAreas - minArea
        diamDeference = maxDiameter - minDiameter
        hueDifference = maxHue - minHue
        brightnessDifference = maxBrightness - minBrightness

        
        let safePadding: CGFloat = 30


        let scaleRate = (screenHeight - safePadding * 2) / sumOfDiameters

        
        var previuoseBottomY: CGFloat = 0
        
        activeCircles.forEach { (circle) in

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
                
                
                let curentArea = circle.area
                
                let newHue = minHue + ((curentArea - minArea)/areaDeference) * (hueDifference)
                
                let newBrightness = minBrightness + ((curentArea - minDiameter)/areaDeference) * (brightnessDifference)
                
                
                circle.absorb(movedCircle, with: UIColor(hue: newHue, saturation: 1, brightness: newBrightness, alpha: 0.9))
                removeFromCircles(view: movedCircle)
                break
            }
        }
    }
    
    private func removeFromCircles(view: CircleView) {
        for (index, circle) in activeCircles.enumerated() {
            if circle == view {
                activeCircles.remove(at: index)
                if activeCircles.count == 1 {
                    moveLastCircleToCenter()
                }
                break
            }
        }
    }
    
    private func moveLastCircleToCenter() {
        activeCircles.first?.center.x = self.view.center.x
        activeCircles.first?.center.y = self.view.center.y
    }
}
