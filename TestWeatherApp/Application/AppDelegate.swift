//
//  AppDelegate.swift
//  TestWeatherApp
//
//  Created by Sergei Veretennikov on 20.02.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerDependencies()
        setupScreen()
        return true
    }

    private func registerDependencies() {
        Resolver.register(
            INetworkService.self,
            implements: {
                NetworkService()
            },
            withProtocols: {
                [
                    IGetCityUseCase.self,
                    IGetCitiesByNamesUseCase.self
                ]
            }
        )

        Resolver.register(IFavoritesRepository.self) {
            FavoritesRepository()
        }
    }

    private func setupScreen() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainTabBar()
        window?.makeKeyAndVisible()
    }
}

