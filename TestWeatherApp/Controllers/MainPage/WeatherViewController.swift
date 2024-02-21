import UIKit

class WeatherViewController: UIViewController {
    enum ViewType: String {
        case mainPage = "Main page"
        case favorites = "Favorites"
    }

    private let debouncer = Debouncer()

    let tableView = UITableView().forAutolayout()
    var viewModel: IWeatherViewModel?
    lazy var searchBar: UISearchBar = UISearchBar()
    private lazy var pullToRefresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        setupScreen()
        fetchData()
        
        tableView.refreshControl = pullToRefresh
        pullToRefresh.addTarget(nil, action: #selector(pullToRefreshTriggered), for: .primaryActionTriggered)

        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        tableView.keyboardDismissMode = .onDrag
        navigationItem.titleView = searchBar
    }

    init(viewModel: IWeatherViewModel) {
        super.init(nibName: nil, bundle: nil)
        title = ViewType.mainPage.rawValue
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fetchData(refreshing: Bool = false) {
        viewModel?.loadCities(refreshing: refreshing) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    if refreshing {
                        self?.pullToRefresh.endRefreshing()
                    }
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }

    private func setupScreen() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.id)
        tableView.backgroundColor = .backgroundColor
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc
    private func pullToRefreshTriggered() {
        fetchData(refreshing: true)
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.id, for: indexPath)
        guard let cell = cell as? WeatherCell, let viewModel else { return UITableViewCell() }
        cell.setupCell(viewModel: WeatherCellViewModel(city: viewModel.getCellModel(at: indexPath.row)))
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfCities() ?? 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? WeatherCell,
              let viewModel = cell.viewModel else { return }
        let detailsViewController = DetailsViewController(viewModel: DetailsViewModel(city: viewModel.getCityData()))
        navigationController?.pushViewController(detailsViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewModel else { return }
        if viewModel.numberOfCities() % 10 == 0, indexPath.row == viewModel.numberOfCities() - 2 {
            fetchData()
        }
    }
}

extension WeatherViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debouncer.debounce(timeout: 1) {
            guard let viewModel = self.viewModel as? WeatherSearchable else { return }
            viewModel.searchFor(city: searchText)
            self.fetchData()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}
