import UIKit

extension UIView {
    func forAutolayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
