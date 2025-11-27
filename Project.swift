import ProjectDescription

let project = Project(
    name: "UI_Lab",
    packages: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.6.0"),
        .package(url: "https://github.com/guoyingtao/Mantis.git", .upToNextMajor(from: "2.23.0")),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMajor(from: "11.0.0"))
    ],
    targets: [
        .target(
            name: "UI_Lab",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.UI-Lab",
            infoPlist: .extendingDefault(
                with: [
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": true,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ]
                            ]
                        ]
                    ],
                    "UILaunchScreen": [
                        "UIImageName": "",
                        "UIColorName": "LaunchBackgroundColor"
                    ],
                    "UILaunchStoryboardName": "LaunchScreen"
                ]
            ),
            sources: ["UI_Lab/Sources/**"],
            resources: ["UI_Lab/Resources/**"],
            dependencies: [
                .package(product: "SnapKit"),
                .package(product: "Mantis"),
                .package(product: "FirebaseFirestore"),
                .package(product: "FirebaseMessaging"),
            ]
        ),
        .target(
            name: "UI_LabTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.UI-LabTests",
            infoPlist: .default,
            sources: ["UI_Lab/Tests/**"],
            resources: [],
            dependencies: [.target(name: "UI_Lab")]
        ),
    ]
)
