//
//  RemoteConfig.swift
//  Clima
//
//  Created by 井本智博 on 2024/09/21.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import Firebase
import FirebaseRemoteConfig


class RemoteConfigManager {

    private let remoteConfig = RemoteConfig.remoteConfig()
    static let sharedChecker = RemoteConfigManager()

    public func setApplicationDidBecomeActive() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc private func applicationDidBecomeActive() {
        fetchRemoteConfigAndCheckVersion()
    }

    private func fetchRemoteConfigAndCheckVersion() {
        remoteConfig.fetch(withExpirationDuration: 0) { (status, error) in
            guard error == nil else {
                print("error in fetching. value: \(error)")
                return
            }
            self.remoteConfig.fetchAndActivate { _, _ in
                if self.checkVersion() {
                    self.showUpdateAlertIfNeeded()
                }
            }
        }
    }

    private func checkVersion() -> Bool {
        let currentVersion = remoteConfig.configValue(forKey: "current_version").stringValue ?? ""
        let localVersionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        return currentVersion != localVersionString
    }

    private func showUpdateAlertIfNeeded() {
        guard let rootViewController = getTopViewController() else { return }

        let alertController = UIAlertController(title: "アップデートが必要です", message: "新しいバージョンがApp Storeにあります。アップデートしてください。", preferredStyle: .alert)

        let updateAction = UIAlertAction(title: "アップデート", style: .default) { _ in
            guard let url = URL(string: "https://www.apple.com/jp/app-store/"),
                  UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

        alertController.addAction(updateAction)
        rootViewController.present(alertController, animated: true, completion: nil)
    }

    private func getTopViewController(_ viewController: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController {
            return getTopViewController(navigationController.visibleViewController)
        } else if let tabBarController = viewController as? UITabBarController, let selected = tabBarController.selectedViewController {
            return getTopViewController(selected)
        } else if let presented = viewController?.presentedViewController {
            return getTopViewController(presented)
        } else {
            return viewController
        }
    }
}

