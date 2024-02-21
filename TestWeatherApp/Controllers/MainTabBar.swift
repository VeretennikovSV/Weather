//
//  MainTabBar.swift
//  TestWeatherApp
//
//  Created by Sergei Veretennikov on 20.02.2024.
//

import UIKit

class MainTabBar: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().isTranslucent = true

        let mainNavigation = DefaultNavigation(
            barTitle: "Main",
            barImage: "home",
            rootViewController: WeatherViewController(viewModel: WeatherViewModel())
        )

        let favoritesNavigation = DefaultNavigation(
            barTitle: "Favorites",
            barImage: "favorites",
            rootViewController: FavoritesViewController(viewModel: FavoritesCitiesWeatherViewModel())
        )
        
        setViewControllers([mainNavigation, favoritesNavigation], animated: false)
    }
}
