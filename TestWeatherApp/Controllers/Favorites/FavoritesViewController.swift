import UIKit

final class FavoritesViewController: WeatherViewController {
    private let debouncer = Debouncer()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = nil
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    override init(viewModel: IWeatherViewModel) {
        super.init(viewModel: viewModel)
        title = ViewType.favorites.rawValue
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavorites), name: .favoritesChanged, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func updateFavorites() {
        debouncer.debounce(timeout: 1) {
            self.fetchData()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .favoritesChanged, object: nil)
    }
}
