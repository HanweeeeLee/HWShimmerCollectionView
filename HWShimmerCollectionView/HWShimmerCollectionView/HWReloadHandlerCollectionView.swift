//
//  HWReloadHandlerCollectionView.swift
//  HWShimmerCollectionView
//
//  Created by hanwe on 2021/02/18.
//

import UIKit

public class HWReloadHandlerCollectionView: UICollectionView {
    var reloadCompleteHandler: (() -> ())?
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if let closure = self.reloadCompleteHandler {
            closure()
        }
    }
}
