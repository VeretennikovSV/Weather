import UIKit

final class DefaultNavigation: UINavigationController {
    convenience init(barTitle: String, barImage: String, rootViewController: UIViewController) {
        self.init(rootViewController: rootViewController)
        tabBarItem.title = barTitle
        tabBarItem.setTitleTextAttributes(
            [.font: UIFont.systemFont(ofSize: 12)],
            for: .normal
        )
        let image = UIImage(named: barImage)?.withRenderingMode(.alwaysTemplate)
        tabBarItem.image = image
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
