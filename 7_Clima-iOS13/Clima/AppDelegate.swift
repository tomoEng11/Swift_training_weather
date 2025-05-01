//
//  AppDelegate.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import FirebaseCore
// Push通知用
import FirebaseMessaging
import UserNotifications
import AppsFlyerLib

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        RemoteConfigManager.sharedChecker.setApplicationDidBecomeActive()

        // App IDとthe DevKeyの設定
        AppsFlyerLib.shared().appsFlyerDevKey = Confidential.devKey
        AppsFlyerLib.shared().appleAppID = Confidential.id
        AppsFlyerLib.shared().isDebug = true // TODO debug用
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().start()

        AppsFlyerLib.shared().deepLinkDelegate = self

        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()

        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
        return true
    }

    // ユニバーサルリンクから起動すると呼ばれる
    // UserActivity:クリックしたリンクや、アプリが復元する必要のある情報
    // (Handoffでアプリをアクティブにする時にも呼ばれる)
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping
                     ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // SDKがユーザー情報元に処理してる？？
        AppsFlyerLib.shared().continue(userActivity, restorationHandler: nil)
        return true
    }

    // カスタムURLスキームからアプリを起動した際に呼ばれる
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
      {
          AppsFlyerLib.shared().handleOpen(url, options: options)
          return true
    }

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Oh no! Failed to register for remote notifications with error \(error)")
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate: MessagingDelegate {
    @objc func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase token: \(String(describing: fcmToken))")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(
        _: UNUserNotificationCenter,
        willPresent _: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([[.banner, .list, .sound]])
    }

    func userNotificationCenter(
        _: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        NotificationCenter.default.post(
            name: Notification.Name("didReceiveRemoteNotification"),
            object: nil,
            userInfo: userInfo
        )
        // バッジ数の更新
        if let badgeCount = userInfo["aps"] as? [String: Any],
            let badge = badgeCount["badge"] as? Int {
            UIApplication.shared.applicationIconBadgeNumber = badge
        }
        completionHandler()
    }
}

//MARK: - AppsFlyerLibDelegate
extension AppDelegate: AppsFlyerLibDelegate {
    // インストールのコンバージョンデータ取得成功時
    // organic = 広告なしでのinstall
    // non-organic = 広告経由のinstall
    func onConversionDataSuccess(_ data: [AnyHashable: Any]) {
        print("onConversionDataSuccess data:")
        for (key, value) in data {
            print(key, ":", value)
        }
        if let status = data["af_status"] as? String {
            if (status == "Non-organic") {
                if let sourceID = data["media_source"],
                    let campaign = data["campaign"] {
                    print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                }
            } else {
                print("This is an organic install.")
            }
            if let is_first_launch = data["is_first_launch"] as? Bool,
                is_first_launch {
                print("First Launch")
            } else {
                print("Not First Launch")
            }
        }
    }

    func onConversionDataFail(_ error: Error) {
        print("\(error)")
    }
}

//MARK: - DeepLinkDelegate
extension AppDelegate: DeepLinkDelegate {

    func didResolveDeepLink(_ result: DeepLinkResult) {
        var favoriteNameStr: String?
        switch result.status {
        case .notFound:
            NSLog("[AFSDK] Deep link not found")
            return
        case .failure:
            print("Error %@", result.error!)
            return
        case .found:
            NSLog("[AFSDK] Deep link found")
        }

        guard let deepLinkObj:DeepLink = result.deepLink else {
            NSLog("[AFSDK] Could not extract deep link object")
            return
        }

        if( deepLinkObj.isDeferred == true) {
            NSLog("[AFSDK] This is a deferred deep link")
        } else {
            NSLog("[AFSDK] This is a direct deep link")
        }
        favoriteNameStr = deepLinkObj.deeplinkValue
        print(favoriteNameStr ?? "deep linkの値が取得できていません")
//        walkToSceneWithParams(name: favoriteNameStr!, deepLinkData: deepLinkObj.clickEvent)
    }
}
//
//fileprivate func walkToSceneWithParams(deepLinkObj: DeepLink) {
//    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//    UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
//    guard let favoriteNameStr = deepLinkObj.clickEvent["deep_link_value"] as? String else {
//         print("Could not extract query params from link")
//         return
//    }
//    let destVC = favoriteNameStr + "_vc"
//    if let newVC = storyBoard.instantiateVC(withIdentifier: destVC) {
//       print("AppsFlyer routing to section: \(destVC)")
//
//       UIApplication.shared.windows.first?.rootViewController?.present(newVC, animated: true, completion: nil)
//    } else {
//        print("AppsFlyer: could not find section: \(destVC)")
//    }
//}
