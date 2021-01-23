//
//  Copyright © 2021 Tamas Dancsi. All rights reserved.
//

import UIKit

extension UIView {

    func pulse(duration: TimeInterval) {
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.duration = duration
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0.6
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        opacityAnimation.autoreverses = true
        opacityAnimation.repeatCount = 1

        let scaleAnimationX = CABasicAnimation(keyPath: "transform.scale.x")
        scaleAnimationX.fromValue = 1
        scaleAnimationX.toValue = 1.3
        scaleAnimationX.autoreverses = true

        let scaleAnimationY = CABasicAnimation(keyPath: "transform.scale.y")
        scaleAnimationY.fromValue = 1
        scaleAnimationY.toValue = 1.3
        scaleAnimationY.autoreverses = true

        layer.add(opacityAnimation, forKey: "animateOpacity")
        layer.add(scaleAnimationX, forKey: "transform.scale.x")
        layer.add(scaleAnimationY, forKey: "transform.scale.y")
    }
}
