import ProjectDescription

let project = Project(
    name: "UI_Lab",
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
            dependencies: []
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
