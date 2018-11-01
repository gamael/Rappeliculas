//
//  Card.swift
//  Cards
//
//  Created by Paolo on 09/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

// TODO: - Risolvere il problema del layout dopo l' animazione passando il backgroundIV al detailVC
// TODO: - Trovare il frame originario relativo alla view del VC della card ( in una table )

import UIKit

@objc public protocol CardDelegate {
    @objc optional func cardDidTapInside(card: Card)
    @objc optional func cardWillShowDetailView(card: Card)
    @objc optional func cardDidShowDetailView(card: Card)
    @objc optional func cardWillCloseDetailView(card: Card)
    @objc optional func cardDidCloseDetailView(card: Card)
    @objc optional func cardIsShowingDetail(card: Card)
    @objc optional func cardIsHidingDetail(card: Card)
    @objc optional func cardDetailIsScrolling(card: Card)

    @objc optional func cardHighlightDidTapButton(card: CardHighlight, button: UIButton)
    @objc optional func cardPlayerDidPlay(card: CardPlayer)
    @objc optional func cardPlayerDidPause(card: CardPlayer)
}

@IBDesignable open class Card: UIView, CardDelegate {
    // Storyboard Inspectable vars
    /**
     Color for the card's labels.
     */
    @IBInspectable public var textColor: UIColor = UIColor.black
    /**
     Amount of blur for the card's shadow.
     */
    @IBInspectable public var shadowBlur: CGFloat = 14 {
        didSet {
            layer.shadowRadius = shadowBlur
        }
    }

    /**
     Alpha of the card's shadow.
     */
    @IBInspectable public var shadowOpacity: Float = 0.6 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }

    /**
     Color of the card's shadow.
     */
    @IBInspectable public var shadowColor: UIColor = UIColor.gray {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }

    /**
     The image to display in the background.
     */
    @IBInspectable public var backgroundImage: UIImage? {
        didSet {
            backgroundIV.image = backgroundImage
        }
    }

    /**
     Corner radius of the card.
     */
    @IBInspectable public var cardRadius: CGFloat = 20 {
        didSet {
            layer.cornerRadius = cardRadius
        }
    }

    /**
     Insets between card's content and edges ( in percentage )
     */
    @IBInspectable public var contentInset: CGFloat = 6 {
        didSet {
            insets = LayoutHelper(rect: originalFrame).X(contentInset)
        }
    }

    /**
     Color of the card's background.
     */
    open override var backgroundColor: UIColor? {
        didSet(new) {
            if let color = new { backgroundIV.backgroundColor = color }
            if backgroundColor != UIColor.clear { backgroundColor = UIColor.clear }
        }
    }

    /**
     contentViewController  -> The view controller to present when the card is tapped
     from                   -> Your current ViewController (self)
     */
    public func shouldPresent(_ contentViewController: UIViewController?, from superVC: UIViewController?, fullscreen: Bool = false) {
        if let content = contentViewController {
            self.superVC = superVC
            detailVC.addChildViewController(content)
            detailVC.detailView = content.view
            detailVC.card = self
            detailVC.delegate = delegate
            detailVC.isFullscreen = fullscreen
        }
    }

    /**
     If the card should display parallax effect.
     */
    public var hasParallax: Bool = true {
        didSet {
            if motionEffects.isEmpty && hasParallax { goParallax() }
            else if !hasParallax && !motionEffects.isEmpty { motionEffects.removeAll() }
        }
    }

    /**
     Delegate for the card. Should extend your VC with CardDelegate.
     */
    public var delegate: CardDelegate?

    // Private Vars
    fileprivate var tap = UITapGestureRecognizer()
    fileprivate var detailVC = DetailViewController()
    weak var superVC: UIViewController?
    var originalFrame = CGRect.zero
    public var backgroundIV = UIImageView()
    public var insets = CGFloat()
    var isPresenting = false

    // MARK: - View Life Cycle

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    open func initialize() {
        // Tap gesture init
        addGestureRecognizer(tap)
        tap.delegate = self
        tap.cancelsTouchesInView = false

        detailVC.transitioningDelegate = self

        // Adding Subviews
        addSubview(backgroundIV)

        backgroundIV.isUserInteractionEnabled = true

        if backgroundIV.backgroundColor == nil {
            backgroundIV.backgroundColor = UIColor.white
            super.backgroundColor = UIColor.clear
        }
    }

    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        originalFrame = rect

        layer.shadowOpacity = shadowOpacity
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = shadowBlur
        layer.cornerRadius = cardRadius

        backgroundIV.image = backgroundImage
        backgroundIV.layer.cornerRadius = layer.cornerRadius
        backgroundIV.clipsToBounds = true
        backgroundIV.contentMode = .scaleAspectFill

        backgroundIV.frame.origin = bounds.origin
        backgroundIV.frame.size = CGSize(width: bounds.width, height: bounds.height)
        contentInset = 6
    }

    // MARK: - Layout

    open func layout(animating _: Bool = true) {}

    // MARK: - Actions

    @objc func cardTapped() {
        delegate?.cardDidTapInside?(card: self)

        if let vc = superVC {
            vc.present(detailVC, animated: true, completion: nil)
        } else {
            resetAnimated()
        }
    }

    // MARK: - Animations

    private func pushBackAnimated() {
        UIView.animate(withDuration: 0.2, animations: { self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95) })
    }

    private func resetAnimated() {
        UIView.animate(withDuration: 0.2, animations: { self.transform = CGAffineTransform.identity })
    }

    func goParallax() {
        let amount = 20

        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount

        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount

        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        addMotionEffect(group)
    }
}

// MARK: - Transition Delegate

extension Card: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator(presenting: true, from: self)
    }

    public func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Animator(presenting: false, from: self)
    }
}

// MARK: - Gesture Delegate

extension Card: UIGestureRecognizerDelegate {
    open override func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
        cardTapped()
    }

    open override func touchesCancelled(_: Set<UITouch>, with _: UIEvent?) {
        resetAnimated()
    }

    open override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        if let superview = self.superview {
            originalFrame = superview.convert(frame, to: nil)
        }

        pushBackAnimated()
    }
}

// MARK: - Helpers

extension UILabel {
    func lineHeight(_ height: CGFloat) {
        let attributedString = NSMutableAttributedString(string: text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = height
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        attributedText = attributedString
    }
}
