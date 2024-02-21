import UIKit

extension UIImageView {
    func setImage(from url: String?) {
        let url = URL(string: url ?? "")
        guard let pathComponents = url?.pathComponents else { return }
        let bundleImageName = pathComponents[pathComponents.count - 2] + (pathComponents.last ?? "")
        DispatchQueue.main.async {
            self.image = UIImage(named: bundleImageName)
        }
    }
}
