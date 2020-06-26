//
//  LoaderView.swift
//  Example
//

import UIKit

// TODO: improve
class LoaderView: UIView {
    private var spinner: UIActivityIndicatorView?

    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        self.spinner = UIActivityIndicatorView(style: .whiteLarge)
        self.spinner?.hidesWhenStopped = true
        self.addSubview(self.spinner!)
        self.highlightIfNeeded()
    }

    /// - SeeAlso: NSCoding.init?(coder:)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func start() {
        self.spinner?.addConstraints([
                         equal(self, \.centerYAnchor, \.centerYAnchor, constant: 0),
                         equal(self, \.centerXAnchor, \.centerXAnchor, constant: 0)
                     ])
        self.spinner?.startAnimating()
    }
    func stop() {
        self.spinner?.stopAnimating()
    }
}
