import UIKit

public class MovableImageView: UIImageView, UIGestureRecognizerDelegate {
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override init(image: UIImage?) {
        super.init(image: image)
        userInteractionEnabled = true
        movableGestureRecognizers.forEach(addGestureRecognizer)
    }
    var movableGestureRecognizers: [UIGestureRecognizer] {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragGesture(_:)))
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotateGesture(_:)))
        rotationGestureRecognizer.delegate = self
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture(_:)))
        pinchGestureRecognizer.delegate = self
        
        return [panGestureRecognizer, rotationGestureRecognizer, pinchGestureRecognizer]
    }
    @objc func dragGesture(sender: UIPanGestureRecognizer) {
        let transform = self.transform
        self.transform = CGAffineTransformIdentity
        let point = sender.translationInView(self)
        let movedPoint = CGPoint(x: center.x + point.x, y: center.y + point.y)
        center = movedPoint
        self.transform = transform
        sender.setTranslation(CGPoint.zero, inView: self)
    }
    @objc func rotateGesture(sender: UIRotationGestureRecognizer) {
        self.transform = CGAffineTransformConcat(self.transform, CGAffineTransformMakeRotation(sender.rotation))
        sender.rotation = 0.0
    }
    @objc func pinchGesture(sender: UIPinchGestureRecognizer) {
        let transform = self.transform
        self.transform = CGAffineTransformIdentity
        let scale = sender.scale
        let center = self.center
        frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width * scale, height: frame.height * scale)
        self.center = center
        self.transform = transform
        sender.scale = 1.0
    }
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (gestureRecognizer is UIRotationGestureRecognizer || gestureRecognizer is UIPinchGestureRecognizer) && (otherGestureRecognizer is UIRotationGestureRecognizer || otherGestureRecognizer is UIPinchGestureRecognizer)
    }
}