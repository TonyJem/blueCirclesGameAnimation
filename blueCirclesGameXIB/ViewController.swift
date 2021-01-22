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
    
    var activeCircles = [CircleView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activeCircles = circles
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
        activeCircles[0].center.x = self.view.center.x
        activeCircles[0].center.y = self.view.center.y
    }
}
