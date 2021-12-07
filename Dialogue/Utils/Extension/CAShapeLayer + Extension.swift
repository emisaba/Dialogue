import UIKit

extension CAShapeLayer {
    
    static func createPulseAnimation() -> CAShapeLayer {
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero,
                                      radius: 30,
                                      startAngle: 0,
                                      endAngle: .pi * 2,
                                      clockwise: true)
        layer.path = circularPath.cgPath
        layer.strokeColor = CellColorType.pink.cellColor.withAlphaComponent(0.5).cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 10
        return layer
    }
}
