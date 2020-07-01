//
//  ScreenshotHelper.swift
//  SecureTradingUI
//

import UIKit

extension ScreenshotHelper {
    enum CoveringStyle {
        case blur
        case image(UIImage)
    }
}

/// A helper class that adds and removes overlay view on top of the current window
/// in the case of switching of the app between background/foreground modes
class ScreenshotHelper {
    private var coveringView: UIView?
    private var coveringStyle: CoveringStyle = .blur

    init() { }

    func register(coveringStyle: CoveringStyle = .blur) {
        self.coveringStyle = coveringStyle
        NotificationCenter.default.addObserver(self, selector: #selector(ScreenshotHelper.willDisappear(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScreenshotHelper.willAppear(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScreenshotHelper.willAppear(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    func unregister() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc private func willDisappear(_ notification: NSNotification) {
        // Add overlay

        // get top view
        guard let topView = UIApplication.shared.windows.first(where: {$0.isKeyWindow})?.rootViewController?.view else { return }
        switch coveringStyle {
        case .blur:
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            coveringView = UIVisualEffectView(effect: blurEffect)
        case .image(let image):
            coveringView = UIImageView(image: image)
            coveringView?.contentMode = .bottom
            coveringView?.translatesAutoresizingMaskIntoConstraints = false
        }

        // just double checking
        guard coveringView != nil else { return }

        topView.addSubview(coveringView!)

        coveringView!.addConstraints([
            equal(topView, \.topAnchor, \.topAnchor, constant: 0),
            equal(topView, \.bottomAnchor, \.bottomAnchor, constant: 0),
            equal(topView, \.leadingAnchor, \.leadingAnchor, constant: 0),
            equal(topView, \.trailingAnchor, \.trailingAnchor, constant: 0)
        ])
    }

    @objc private func willAppear(_ notification: NSNotification) {
        // Remove overlay
        //swiftlint: disable multiple_closures_with_trailing_closure
        UIView.animate(withDuration: 0.3, animations: {
            self.coveringView?.alpha = 0.0
        }, completion: { (finished) in
            if finished {
                self.coveringView?.removeFromSuperview()
            }
        })
        //swiftlint: enable multiple_closures_with_trailing_closure
    }
}
