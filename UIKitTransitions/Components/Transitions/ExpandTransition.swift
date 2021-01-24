//
//  Copyright © 2021 Tamas Dancsi. All rights reserved.
//

import UIKit

class ExpandTransition: NSObject, UIViewControllerAnimatedTransitioning {

    enum Mode: Int {
        case present, dismiss
    }

    var mode: Mode = .present

    weak var selectedCell: CityCell?

    private let duration: TimeInterval = 0.15

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch mode {
        case .present:
            startExpandingTransition(context: transitionContext)

        case .dismiss:
            startFadingOutTransition(context: transitionContext)
        }
    }

    // MARK: - Expanding

    private func startExpandingTransition(context: UIViewControllerContextTransitioning) {
        guard let fromViewController = context.viewController(forKey: .from),
              let toViewController = context.viewController(forKey: .to) as? DetailViewController,
              let fromView = selectedCell,
              let fromGlobalPoint = fromView.superview?.convert(fromView.frame.origin, to: nil) else {
            return
        }

        /// Displaying toViewController shifted down
        let containerView = context.containerView
        containerView.addSubview(toViewController.view)

        let toFrame = fromViewController.view.frame
        var fromFrame = toFrame
        fromFrame.origin.y = fromGlobalPoint.y
        toViewController.view.frame = fromFrame

        UIView.animate(withDuration: duration) {
            /// Moving toViewController up
            toViewController.view.frame = toFrame
        } completion: { _ in
            context.completeTransition(true)
        }
    }

    // MARK: - Fading out

    private func startFadingOutTransition(context: UIViewControllerContextTransitioning) {
        guard let fromViewController = context.viewController(forKey: .from) else {
            return
        }

        UIView.animate(withDuration: duration, animations: {
            fromViewController.view.alpha = 0
        }, completion: { _ in
            context.completeTransition(true)
            fromViewController.view.removeFromSuperview()
        })
    }
}
