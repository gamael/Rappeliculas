//
//  DetailViewController.swift
//  Cards
//
//  Created by Paolo Cuscela on 23/10/17.
//

import UIKit

internal class DetailViewController: UIViewController {
    var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    weak var detailView: UIView?
    var scrollView = UIScrollView()
    var snap = UIView()
    weak var card: Card!
    weak var delegate: CardDelegate?
    var isFullscreen = false {
        didSet { scrollViewOriginalYPosition = isFullscreen ? 0 : 40 }
    }

    fileprivate var xButton = XButton()
    fileprivate var scrollPosition = CGFloat()
    fileprivate var scrollViewOriginalYPosition = CGFloat()

    override var prefersStatusBarHidden: Bool {
        if isFullscreen { return true }
        else { return false }
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }

        snap = UIScreen.main.snapshotView(afterScreenUpdates: true)
        view.addSubview(blurView)
        view.addSubview(scrollView)

        if let detail = detailView {
            scrollView.addSubview(detail)
            detail.alpha = 0
            detail.autoresizingMask = .flexibleWidth
        }

        blurView.frame = view.bounds

        scrollView.layer.backgroundColor = detailView?.backgroundColor?.cgColor ?? UIColor.white.cgColor
        scrollView.layer.cornerRadius = isFullscreen ? 0 : 20

        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false

        xButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissVC)))
        xButton.isUserInteractionEnabled = true
        view.isUserInteractionEnabled = true
    }

    override func viewWillAppear(_: Bool) {
        scrollView.addSubview(card.backgroundIV)
        delegate?.cardWillShowDetailView?(card: card)
    }

    override func viewDidAppear(_: Bool) {
        // originalFrame = scrollView.frame

        if isFullscreen {
            view.addSubview(xButton)
        }

        view.insertSubview(snap, belowSubview: blurView)

        if let detail = detailView {
            detail.alpha = 1
            detail.frame = CGRect(x: 0,
                                  y: card.backgroundIV.bounds.maxY,
                                  width: scrollView.frame.width,
                                  height: detail.frame.height)

            scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: detail.frame.maxY)

            xButton.frame = CGRect(x: scrollView.frame.maxX - 20 - 40,
                                   y: scrollView.frame.minY + 20,
                                   width: 40,
                                   height: 40)
        }

        delegate?.cardDidShowDetailView?(card: card)
        scrollView.contentOffset.y = 0 // Jie - Sometimes backgroundIV is pushed down. This make sure it is pinned to top of scrollView
    }

    override func viewWillDisappear(_: Bool) {
        delegate?.cardWillCloseDetailView?(card: card)
        detailView?.alpha = 0
        snap.removeFromSuperview()
        xButton.removeFromSuperview()
    }

    override func viewDidDisappear(_: Bool) {
        delegate?.cardDidCloseDetailView?(card: card)
    }

    // MARK: - Layout & Animations for the content ( rect = Scrollview + card + detail )

    func layout(_ rect: CGRect, isPresenting: Bool, isAnimating: Bool = true, transform: CGAffineTransform = CGAffineTransform.identity) {
        // Layout for dismiss
        guard isPresenting else {
            scrollView.frame = rect.applying(transform)
            scrollView.layer.cornerRadius = card.cardRadius
            card.backgroundIV.frame = scrollView.bounds
            card.layout(animating: isAnimating)
            return
        }

        // Layout for present in fullscreen
        if isFullscreen {
            scrollView.layer.cornerRadius = 0
            scrollView.frame = view.bounds
            scrollView.frame.origin.y = 0

            // Layout for present in non-fullscreen
        } else {
            scrollView.frame.size = CGSize(width: LayoutHelper.YScreen(90), height: LayoutHelper.XScreen(100) - 20)
            scrollView.center = blurView.center
            scrollView.frame.origin.y = 40
        }

        scrollView.frame = scrollView.frame.applying(transform)

        card.backgroundIV.frame.origin = scrollView.bounds.origin
        card.backgroundIV.frame.size = CGSize(width: scrollView.bounds.width,
                                              height: card.backgroundIV.bounds.height)
        card.layout(animating: isAnimating)
    }

    // MARK: - Actions

    @objc func dismissVC() {
        scrollView.contentOffset.y = 0
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ScrollView Behaviour

extension DetailViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        let offset = scrollView.frame.origin.y - scrollViewOriginalYPosition

        // Behavior when scroll view is pulled down
        if y < 0 {
            scrollView.frame.origin.y -= y / 2
            scrollView.contentOffset.y = 0

            // Behavior when scroll view is pulled down and then up
        } else if offset > 0 {
            scrollView.contentOffset.y = 0
            scrollView.frame.origin.y -= y / 2
        }

        guard offset < 60 else { dismissVC(); return }
        card.delegate?.cardDetailIsScrolling?(card: card)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset _: UnsafeMutablePointer<CGPoint>) {
        let offset = scrollView.frame.origin.y - scrollViewOriginalYPosition

        // Pull down speed calculations
        let max = 4.0
        let min = 2.0
        var speed = Double(-velocity.y)
        if speed > max { speed = max }
        if speed < min { speed = min }
        speed = (max / speed * min) / 10

        guard offset < 60 else { dismissVC(); return }
        guard offset > 0 else { return }

        // Come back after pull animation
        UIView.animate(withDuration: speed, animations: {
            scrollView.frame.origin.y = self.scrollViewOriginalYPosition
            self.scrollView.contentOffset.y = 0
        })
    }
}

class XButton: UIButton {
    private let circle = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    override var frame: CGRect {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(circle)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let xPath = UIBezierPath()
        let xLayer = CAShapeLayer()
        let inset = rect.width * 0.3

        xPath.move(to: CGPoint(x: inset, y: inset))
        xPath.addLine(to: CGPoint(x: rect.maxX - inset, y: rect.maxY - inset))

        xPath.move(to: CGPoint(x: rect.maxX - inset, y: inset))
        xPath.addLine(to: CGPoint(x: inset, y: rect.maxY - inset))

        xLayer.path = xPath.cgPath

        xLayer.strokeColor = UIColor.white.cgColor
        xLayer.lineWidth = 2.0
        layer.addSublayer(xLayer)

        circle.frame = rect
        circle.layer.cornerRadius = circle.bounds.width / 2
        circle.clipsToBounds = true
        circle.isUserInteractionEnabled = false
    }
}
