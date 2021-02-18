//
//  UIViewExtension.swift
//  HWShimmerCollectionView
//
//  Created by hanwe on 2021/02/18.
//

import Foundation
import UIKit

extension UIView {
    
    func startShimmering() {
        let light = UIColor(white: 0, alpha: 0.1).cgColor
        let dark = UIColor.black.cgColor
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [dark, light, dark]
        gradient.frame = CGRect(x: -bounds.size.width, y: 0, width: 3 * bounds.size.width, height: bounds.size.height)
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint   = CGPoint(x: 1.0, y: 0.5)
        gradient.locations  = [0.49, 0.5, 0.51]
        
        layer.mask = gradient
        
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue   = [0.8, 0.9, 1.0]
        
        animation.duration = 1.3
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.isRemovedOnCompletion = false
        
        gradient.add(animation, forKey: "shimmer")
    }
    
    func stopShimmering(){
        DispatchQueue.main.async {
            self.layer.mask = nil
        }
    }
    
    func fadeOutForHWCollectionView(duration: TimeInterval = 0.2, completeHandler:@escaping () -> ()) {
        self.alpha = 1.0
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: { (finished: Bool) -> Void in
            completeHandler()
        })
    }
    
    func removeAllSubviewForHWCollectionView() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }
    
}
