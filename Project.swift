import ProjectDescription

let project = Project(
    name: "Allkdic",
    options: .options(
        defaultKnownRegions: ["en", "ko", "Base"],
        developmentRegion: "en"
    ),
    settings: .settings(
        base: [
            "MACOSX_DEPLOYMENT_TARGET": "14.0",
            "SWIFT_VERSION": "6.0",
            "DEVELOPMENT_TEAM": "N2C267LBVY",
        ],
        configurations: [
            .debug(name: "Debug"),
            .release(name: "Release"),
        ]
    ),
    targets: [
        .target(
            name: "Allkdic",
            destinations: .macOS,
            product: .app,
            bundleId: "kr.xoul.allkdic",
            deploymentTargets: .macOS("14.0"),
            infoPlist: .file(path: "Allkdic/Allkdic-Info.plist"),
            sources: ["Allkdic/**/*.swift", "Allkdic/**/*.m"],
            resources: [
                "Resources/Images.xcassets",
                "Resources/Localizable/**",
            ],
            entitlements: .file(path: "Allkdic/Allkdic.entitlements"),
            dependencies: [
                .target(name: "LauncherApplication"),
                .sdk(name: "Cocoa", type: .framework),
                .sdk(name: "WebKit", type: .framework),
                .sdk(name: "Carbon", type: .framework),
                .sdk(name: "Security", type: .framework),
                .sdk(name: "ServiceManagement", type: .framework),
            ],
            settings: .settings(
                base: [
                    "CLANG_ENABLE_MODULES": "YES",
                    "SWIFT_OBJC_BRIDGING_HEADER": "$(SRCROOT)/Allkdic/Allkdic-Bridging-Header.h",
                    "HEADER_SEARCH_PATHS": "$(SRCROOT)/Allkdic/Utils",
                    "CODE_SIGN_ENTITLEMENTS": "Allkdic/Allkdic.entitlements",
                    "CODE_SIGN_IDENTITY": "Mac Developer",
                    "OTHER_CODE_SIGN_FLAGS": "--deep",
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                    "COMBINE_HIDPI_IMAGES": "YES",
                ]
            )
        ),
        .target(
            name: "AllkdicTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "kr.xoul.AllkdicTests",
            deploymentTargets: .macOS("14.0"),
            infoPlist: .file(path: "AllkdicTests/Info.plist"),
            sources: ["AllkdicTests/**/*.swift"],
            dependencies: [
                .target(name: "Allkdic"),
            ],
            settings: .settings(
                base: [
                    "BUNDLE_LOADER": "$(TEST_HOST)",
                    "TEST_HOST": "$(BUILT_PRODUCTS_DIR)/Allkdic.app/Contents/MacOS/Allkdic",
                ]
            )
        ),
        .target(
            name: "LauncherApplication",
            destinations: .macOS,
            product: .app,
            bundleId: "kr.xoul.allkdic.LauncherApplication",
            deploymentTargets: .macOS("14.0"),
            infoPlist: .file(path: "LauncherApplication/Info.plist"),
            sources: ["LauncherApplication/**/*.swift"],
            resources: [
                "LauncherApplication/Assets.xcassets",
                "LauncherApplication/Base.lproj/Main.storyboard",
            ],
            entitlements: .file(path: "LauncherApplication/LauncherApplication.entitlements"),
            settings: .settings(
                base: [
                    "CLANG_ENABLE_MODULES": "YES",
                    "CODE_SIGN_ENTITLEMENTS": "LauncherApplication/LauncherApplication.entitlements",
                    "CODE_SIGN_IDENTITY": "Mac Developer",
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                    "COMBINE_HIDPI_IMAGES": "YES",
                    "SKIP_INSTALL": "YES",
                ]
            )
        ),
    ],
    schemes: [
        .scheme(
            name: "Allkdic",
            shared: true,
            buildAction: .buildAction(targets: ["Allkdic"]),
            testAction: .targets(["AllkdicTests"]),
            runAction: .runAction(executable: "Allkdic")
        ),
    ]
)
