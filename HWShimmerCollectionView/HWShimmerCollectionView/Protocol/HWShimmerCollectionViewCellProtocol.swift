//
//  HWShimmerCollectionViewCellProtocol.swift
//  HWShimmerCollectionView
//
//  Created by hanwe on 2021/02/18.
//

import UIKit

public protocol HWShimmerCollectionViewCellProtocol: UICollectionViewCell {
    
    var shimmerBackgroundColor: UIColor { get set }
    var shimmerViewPool: Array<UIView> { get set }
    
    func startShimmer()
    func endShimmer()
}

public extension HWShimmerCollectionViewCellProtocol {
    func startShimmer() {
        shimmerViewPool.map {
            let view: UIView = UIView()
            view.backgroundColor = shimmerBackgroundColor
            $0.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            let constraint1 = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal,
                                                 toItem: $0, attribute: .leading,
                                                 multiplier: 1.0, constant: 0)

            let constraint2 = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal,
                                                 toItem: $0, attribute: .trailing,
                                                 multiplier: 1.0, constant: 0)

            let constraint3 = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal,
                                                 toItem: $0, attribute: .top,
                                                 multiplier: 1.0, constant: 0)

            let constraint4 = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal,
                                                 toItem: $0, attribute: .bottom,
                                                 multiplier: 1.0, constant: 0)
            $0.addConstraints([constraint1, constraint2, constraint3, constraint4])
            $0.startShimmering()
        }
    }
    
    func endShimmer() {
        shimmerViewPool.map {
            $0.removeAllSubviewForHWCollectionView()
            $0.stopShimmering()
            
        }
    }
}
