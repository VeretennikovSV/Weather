import UIKit

final class WeatherCell: UITableViewCell {
    static let id = "WeatherCell"
    private let cityNameLabel = UILabel().forAutolayout()
    private let countryLabel = UILabel().forAutolayout()
    private let degreesLabel = UILabel().forAutolayout()
    private let currentConditionImage = UIImageView().forAutolayout()
    private let currentConditionLabel = UILabel().forAutolayout()
    private let likeButton = UIButton().forAutolayout()
    
    var viewModel: IWeatherCellViewModel?

    func setupCell(viewModel: IWeatherCellViewModel?) {
        self.viewModel = viewModel
        guard let viewModel = viewModel else { return }

        cityNameLabel.text = viewModel.cityName
        cityNameLabel.font = .defaultFont

        degreesLabel.text = viewModel.degreesText
        degreesLabel.font = .systemFont(ofSize: 50, weight: .bold)

        countryLabel.text = viewModel.countryName

        currentConditionImage.setImage(from: viewModel.currentConditionImageName)
        currentConditionImage.backgroundColor = .primaryBackgroundColor
        currentConditionImage.layer.cornerRadius = .s2

        currentConditionLabel.text = viewModel.currentConditionText

        likeButton.setImage(viewModel.isFavorite ? .starFilled : .star, for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoriteChangedNotification), name: .favoritesChanged, object: nil)
        likeButton.addTarget(self, action: #selector(updateFavoriteState), for: .touchUpInside)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        NotificationCenter.default.removeObserver(self, name: .favoritesChanged, object: nil)
        likeButton.removeTarget(self, action: #selector(updateFavoriteState), for: .touchUpInside)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
        contentView.backgroundColor = .backgroundColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConstraints() {
        contentView.addSubviews(
            countryLabel,
            degreesLabel,
            cityNameLabel,
            currentConditionImage,
            currentConditionLabel,
            likeButton
        )

        [countryLabel, cityNameLabel].forEach {
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }

        NSLayoutConstraint.activate([
            currentConditionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .s4),
            currentConditionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .s4),

            currentConditionImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .s4),
            currentConditionImage.topAnchor.constraint(equalTo: currentConditionLabel.bottomAnchor, constant: .s1),
            currentConditionImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.s4),
            currentConditionImage.heightAnchor.constraint(equalToConstant: 64),

            degreesLabel.leadingAnchor.constraint(equalTo: currentConditionImage.trailingAnchor, constant: .s2),
            degreesLabel.topAnchor.constraint(equalTo: currentConditionImage.topAnchor),
            degreesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.s4),

            countryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.s4),
            countryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .s4),
            countryLabel.leadingAnchor.constraint(greaterThanOrEqualTo: currentConditionLabel.trailingAnchor),

            cityNameLabel.trailingAnchor.constraint(equalTo: countryLabel.trailingAnchor),
            cityNameLabel.topAnchor.constraint(equalTo: countryLabel.bottomAnchor, constant: .s1),
            cityNameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: degreesLabel.trailingAnchor),

            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.s4),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.s4)
        ])
    }

    @objc
    private func handleFavoriteChangedNotification() {
        guard let newState = viewModel?.updatedFavoriteState() else { return }
        viewModel?.isFavorite = newState
        updateFavoritesView(status: newState)
    }

    @objc
    private func updateFavoriteState() {
        viewModel?.updateFavoriteState()
        updateFavoritesView(status: viewModel?.isFavorite ?? false)
    }

    private func updateFavoritesView(status: Bool) {
        if status {
            likeButton.setImage(.starFilled, for: .normal)
        } else {
            likeButton.setImage(.star, for: .normal)
        }
    }
}
