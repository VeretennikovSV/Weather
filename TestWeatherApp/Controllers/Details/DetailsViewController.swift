import UIKit

final class DetailsViewController: UIViewController {
    private var viewModel: IDetailsViewModel!

    private var backgroundHeader = UIView().forAutolayout()
    private let cityNameLabel = UILabel().forAutolayout()
    private let countryLabel = UILabel().forAutolayout()
    private let degreesLabel = UILabel().forAutolayout()
    private let feelsLike = UILabel().forAutolayout()
    private let currentConditionImage = UIImageView().forAutolayout()
    private let currentConditionLabel = UILabel().forAutolayout()
    private let cityDescriptionStack = UIStackView().forAutolayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
    }

    init(viewModel: IDetailsViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        setConstraints()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundHeader.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        backgroundHeader.layer.cornerRadius = .s4
        backgroundHeader.backgroundColor = .accent

        degreesLabel.font = .systemFont(ofSize: 102, weight: .medium)
        degreesLabel.text = viewModel.degreesText

        currentConditionImage.setImage(from: viewModel.currentConditionImageName)

        currentConditionLabel.text = viewModel.currentConditionText
        currentConditionLabel.font = .systemFont(ofSize: 32, weight: .medium)

        cityDescriptionStack.axis = .vertical
        cityDescriptionStack.spacing = .s3
        cityDescriptionStack.distribution = .equalSpacing

        feelsLike.text = viewModel.feelslikeText
        feelsLike.font = .defaultFont
    }

    private func setConstraints() {
        view.addSubviews(
            cityDescriptionStack,
            backgroundHeader
        )

        cityDescriptionStack.addArrangedSubviews(
            countryLabelStack(),
            cityNameStack(),
            windSpeedStack(),
            humidityStack(),
            pressureStack()
        )

        backgroundHeader.addSubviews(
            degreesLabel,
            feelsLike,
            currentConditionImage,
            currentConditionLabel
        )

        NSLayoutConstraint.activate([
            backgroundHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundHeader.heightAnchor.constraint(equalToConstant: 300),

            degreesLabel.centerXAnchor.constraint(equalTo: backgroundHeader.centerXAnchor),
            degreesLabel.centerYAnchor.constraint(equalTo: backgroundHeader.centerYAnchor),

            feelsLike.centerXAnchor.constraint(equalTo: degreesLabel.centerXAnchor),
            feelsLike.topAnchor.constraint(equalTo: degreesLabel.bottomAnchor),

            currentConditionImage.leadingAnchor.constraint(equalTo: backgroundHeader.leadingAnchor, constant: .s4),
            currentConditionImage.topAnchor.constraint(equalTo: backgroundHeader.topAnchor, constant: .s4),

            currentConditionLabel.trailingAnchor.constraint(equalTo: backgroundHeader.trailingAnchor, constant: -.s4),
            currentConditionLabel.centerYAnchor.constraint(equalTo: currentConditionImage.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            cityDescriptionStack.topAnchor.constraint(equalTo: backgroundHeader.bottomAnchor, constant: .s2),
            cityDescriptionStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .s4),
            cityDescriptionStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.s4),
        ])
    }

    private func cityNameStack() -> UIStackView {
        baseStack(title: "City", subtitle: viewModel.cityName)
    }

    private func countryLabelStack() -> UIStackView {
        baseStack(title: "Country", subtitle: viewModel.countryName)
    }

    private func windSpeedStack() -> UIStackView {
        baseStack(title: "Wind", subtitle: viewModel.windSpeed)
    }

    private func pressureStack() -> UIStackView {
        baseStack(title: "Pressure", subtitle: viewModel.pressure)
    }

    private func humidityStack() -> UIStackView {
        baseStack(title: "Humidity", subtitle: viewModel.humidity)
    }

    private func baseStack(title: String, subtitle: String) -> UIStackView {
        let stack = UIStackView().forAutolayout()
        stack.alignment = .top
        stack.distribution = .equalSpacing

        stack.axis = .vertical
        stack.spacing = .s1 / 1

        let titleLabel = UILabel()
        let subtitleLabel = UILabel()

        titleLabel.text = "\(title):"
        subtitleLabel.text = subtitle

        titleLabel.font = .mediumFont
        subtitleLabel.font = .defaultFont

        stack.addArrangedSubviews(titleLabel, subtitleLabel)
        stack.sizeToFit()
        return stack
    }
}
