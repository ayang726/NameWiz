//
//  TransitioningDelegate.swift
//  NameWiz
//
//  Created by Alex Yang on 2019-02-06.
//  Copyright © 2019 Alex Yang. All rights reserved.
//

import UIKit

class CustomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.5
    let checkViewDisappearDuration = 0.2
    let checkerViewCountInRow:CGFloat = 20
    let numCheckDisappearAtTheTime = 10
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using context: UIViewControllerContextTransitioning) {
        guard let fromVC = context.viewController(forKey: .from), let toVC = context.viewController(forKey: .to) else {return}
        
        let toVCFinalFrame = context.finalFrame(for: toVC)
        
        let containerView = context.containerView
        
        toVC.view.frame = toVCFinalFrame
        toVC.view.alpha = 1
        
        containerView.addSubview(toVC.view)
        
        let checkViewSize = containerView.frame.width / checkerViewCountInRow
        var checkerViews = [UIView]()
        for i in stride(from: 0, to: containerView.frame.width, by: checkViewSize) {
            for j in stride(from: 0, to: containerView.frame.height, by: checkViewSize) {
                let view = UIView(frame: CGRect(x: i, y: j, width: checkViewSize, height: checkViewSize))
                view.frame.origin = CGPoint(x: i, y: j)
                view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                view.alpha = 1
                checkerViews.append(view)
                containerView.addSubview(view)
                containerView.bringSubviewToFront(view)
            }
        }

        var indexToRemove: Int? {return checkerViews.count > 0 ? Int(arc4random_uniform(UInt32(checkerViews.count))) : nil}

        let number = checkerViews.count/numCheckDisappearAtTheTime
        for i in 0..<number {
            var viewsToRemove = [UIView]()
            for _ in 0..<numCheckDisappearAtTheTime {
                if let index = indexToRemove {
                    viewsToRemove.append(checkerViews.remove(at: index))
                }
            }
            UIView.animate(withDuration: duration/Double(number*numCheckDisappearAtTheTime), delay: duration / Double (number) * Double(i), options: UIView.AnimationOptions.transitionCurlUp , animations: {
                viewsToRemove.forEach({ (view) in
                    view.alpha = 0
                })
            }) { (completed) in
                viewsToRemove.forEach({ (view) in
                    view.removeFromSuperview()
                })
            }
        }
        context.completeTransition(true)
    }
    
}
