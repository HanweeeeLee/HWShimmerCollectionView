//
//  HWShimmerCollectionView.swift
//  HWShimmerCollectionView
//
//  Created by hanwe on 2021/02/18.
//

import UIKit

@objc public protocol HWShimmerCollectionViewDelegate: UICollectionViewDelegate {
    
    func numberOfShimmerCollectionViewCell(_ hwCollectionView: HWShimmerCollectionView) -> UInt
    func shimmerCollectionViewCellIdentifier(_ hwCollectionView: HWShimmerCollectionView) -> String
    
    @objc optional func willApearShimmerCollectionView(_ hwCollectionView: HWShimmerCollectionView)
    @objc optional func didApearShimmerCollectionView(_ hwCollectionView: HWShimmerCollectionView)
    @objc optional func willDisapearShimmerCollectionView(_ hwCollectionView: HWShimmerCollectionView)
    @objc optional func didDisapearShimmerCollectionView(_ hwCollectionView: HWShimmerCollectionView)
    
}

@objc public protocol HWCollectionViewDelegateFlowLayout: HWShimmerCollectionViewDelegate {
    
    @objc optional func hwShimmerCollectionView(_ collectionView: HWShimmerCollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    @objc optional func hwShimmerCollectionView(_ collectionView: HWShimmerCollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    @objc optional func hwShimmerCollectionView(_ collectionView: HWShimmerCollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    @objc optional func hwShimmerCollectionView(_ collectionView: HWShimmerCollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    @objc optional func hwShimmerCollectionView(_ collectionView: HWShimmerCollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    @objc optional func hwShimmerCollectionView(_ collectionView: HWShimmerCollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    
}

public class HWShimmerCollectionView: UIView {
    
    //MARK: private property
    private var flowLayoutDelegate: HWCollectionViewDelegateFlowLayout?
    private var isShimmering: Bool = false
    private var minimumShimmerTimer: Timer?
    private var isOverMinimumShimmerTimer:Bool = true
    
    //MARK: public property
    public lazy var collectionView: HWReloadHandlerCollectionView = HWReloadHandlerCollectionView(frame: self.bounds, collectionViewLayout: UICollectionViewLayout())
    public lazy var shimmerCollectionView: HWReloadHandlerCollectionView = HWReloadHandlerCollectionView(frame: self.bounds, collectionViewLayout: UICollectionViewLayout())
    
    public weak var delegate: HWShimmerCollectionViewDelegate? {
        willSet {
            self.flowLayoutDelegate = newValue as? HWCollectionViewDelegateFlowLayout
        }
        didSet {
            self.collectionView.delegate = self.delegate
        }
    }
    
    public weak var datasource: UICollectionViewDataSource? {
        didSet {
            self.collectionView.dataSource = self.datasource
        }
    }
    
    public var collectionViewLayout: UICollectionViewLayout = .init() {
        didSet {
            self.collectionView.collectionViewLayout = self.collectionViewLayout
        }
    }
    
    public var shimmerCollectionViewLayout: UICollectionViewLayout = .init() {
        didSet {
            self.shimmerCollectionView.collectionViewLayout = self.shimmerCollectionViewLayout
        }
    }
    
    public var showsHorizontalScrollIndicator: Bool = true {
        didSet {
            self.collectionView.showsHorizontalScrollIndicator = self.showsHorizontalScrollIndicator
        }
    }
    
    public var showsVerticalScrollIndicator: Bool = true {
        didSet {
            self.collectionView.showsVerticalScrollIndicator = self.showsVerticalScrollIndicator
        }
    }
    
    public override var backgroundColor: UIColor? {
        didSet {
            self.collectionView.backgroundColor = self.backgroundColor
        }
    }
    
    public var minimumShimmerSecond: CGFloat = 1.5
    public var shimmerCollectionViewFadeOutSecond: CGFloat = 0.15
    
    //MARK: life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        shimmerCollectionViewInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        shimmerCollectionViewInit()
    }
    
    //MARK: private function
    private func shimmerCollectionViewInit() {
        
        self.addSubview(self.collectionView)
        self.collectionView.backgroundColor = .clear
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        let constraint1 = NSLayoutConstraint(item: self.collectionView, attribute: .leading, relatedBy: .equal,
                                             toItem: self, attribute: .leading,
                                             multiplier: 1.0, constant: 0)

        let constraint2 = NSLayoutConstraint(item: self.collectionView, attribute: .trailing, relatedBy: .equal,
                                             toItem: self, attribute: .trailing,
                                             multiplier: 1.0, constant: 0)

        let constraint3 = NSLayoutConstraint(item: self.collectionView, attribute: .top, relatedBy: .equal,
                                             toItem: self, attribute: .top,
                                             multiplier: 1.0, constant: 0)

        let constraint4 = NSLayoutConstraint(item: self.collectionView, attribute: .bottom, relatedBy: .equal,
                                             toItem: self, attribute: .bottom,
                                             multiplier: 1.0, constant: 0)
        self.addConstraints([constraint1, constraint2, constraint3, constraint4])
        
        self.addSubview(self.shimmerCollectionView)
        self.shimmerCollectionView.backgroundColor = .clear
        self.shimmerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        let shimmerConstraint1 = NSLayoutConstraint(item: self.shimmerCollectionView, attribute: .leading, relatedBy: .equal,
                                             toItem: self, attribute: .leading,
                                             multiplier: 1.0, constant: 0)

        let shimmerConstraint2 = NSLayoutConstraint(item: self.shimmerCollectionView, attribute: .trailing, relatedBy: .equal,
                                             toItem: self, attribute: .trailing,
                                             multiplier: 1.0, constant: 0)

        let shimmerConstraint3 = NSLayoutConstraint(item: self.shimmerCollectionView, attribute: .top, relatedBy: .equal,
                                             toItem: self, attribute: .top,
                                             multiplier: 1.0, constant: 0)

        let shimmerConstraint4 = NSLayoutConstraint(item: self.shimmerCollectionView, attribute: .bottom, relatedBy: .equal,
                                             toItem: self, attribute: .bottom,
                                             multiplier: 1.0, constant: 0)
        self.addConstraints([shimmerConstraint1, shimmerConstraint2, shimmerConstraint3, shimmerConstraint4])
        self.shimmerCollectionView.delegate = self
        self.shimmerCollectionView.dataSource = self
        self.shimmerCollectionView.isScrollEnabled = false
        self.shimmerCollectionView.isHidden = true
        
    }
    
    @objc private func minimumShimmerTimerCallback() {
        self.isOverMinimumShimmerTimer = true
    }
    
    //MARK: public function
    
    public func registerShimmerCell(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        self.shimmerCollectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    public func showShimmer() {
        self.delegate?.willApearShimmerCollectionView?(self)
        self.isOverMinimumShimmerTimer = false
        self.shimmerCollectionView.alpha = 1
        self.shimmerCollectionView.isHidden = false
        self.isShimmering = true
        self.shimmerCollectionView.reloadData()
        if self.minimumShimmerTimer?.isValid ?? false {
            self.minimumShimmerTimer?.invalidate()
        }
        self.minimumShimmerTimer = Timer.scheduledTimer(timeInterval: TimeInterval(self.minimumShimmerSecond), target: self, selector: #selector(self.minimumShimmerTimerCallback), userInfo: nil, repeats: false)
        self.delegate?.didApearShimmerCollectionView?(self)
    }
    
    public func hideShimmer() {
        if self.isOverMinimumShimmerTimer {
            self.delegate?.willDisapearShimmerCollectionView?(self)
            self.isShimmering = false
            self.shimmerCollectionView.reloadData()
            self.shimmerCollectionView.fadeOutForHWCollectionView(duration: TimeInterval(self.shimmerCollectionViewFadeOutSecond), completeHandler: {
                self.shimmerCollectionView.isHidden = true
                self.delegate?.didDisapearShimmerCollectionView?(self)
            })
        }
        else {
            DispatchQueue.global(qos: .default).async { [weak self] in
                usleep(3 * 100 * 1000)
                DispatchQueue.main.async { [weak self] in
                    self?.hideShimmer()
                }
            }
        }
    }
}

extension HWShimmerCollectionView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.shimmerCollectionView {
            return Int(self.delegate?.numberOfShimmerCollectionViewCell(self) ?? 0)
        }
        else {
            return 100
        }
    }
      
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let identifier = self.delegate?.shimmerCollectionViewCellIdentifier(self) else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if let shimmerCell = (cell as? HWShimmerCollectionViewCellProtocol) {
            if self.isShimmering {
                (shimmerCell as HWShimmerCollectionViewCellProtocol).startShimmer()
            }
            else {
                (shimmerCell as HWShimmerCollectionViewCellProtocol).endShimmer()
            }
        }

        return cell
    }
    
}

extension HWShimmerCollectionView: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.flowLayoutDelegate?.hwShimmerCollectionView?(self, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? CGSize(width: 0, height: 0)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let edgeInsets:UIEdgeInsets = self.flowLayoutDelegate?.hwShimmerCollectionView?(self, layout: collectionViewLayout, insetForSectionAt: section) ?? .init(top: 0, left: 0, bottom: 0, right: 0)
        return edgeInsets
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.flowLayoutDelegate?.hwShimmerCollectionView?(self, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section) ?? 1
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.flowLayoutDelegate?.hwShimmerCollectionView?(self, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section) ?? 1
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return self.flowLayoutDelegate?.hwShimmerCollectionView?(self, layout: collectionViewLayout, referenceSizeForHeaderInSection: section) ?? CGSize(width: 0, height: 0)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return self.flowLayoutDelegate?.hwShimmerCollectionView?(self, layout: collectionViewLayout, referenceSizeForFooterInSection: section) ?? CGSize(width: 0, height: 0)
    }

}


