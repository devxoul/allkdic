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
            sources: ["Allkdic/**/*.swift"],
            resources: [
                "Resources/Images.xcassets",
                "Resources/Localizable/**",
            ],
            entitlements: .file(path: "Allkdic/Allkdic.entitlements"),
            dependencies: [
                .sdk(name: "Cocoa", type: .framework),
                .sdk(name: "WebKit", type: .framework),
                .sdk(name: "Carbon", type: .framework),
                .sdk(name: "Security", type: .framework),
                .sdk(name: "ServiceManagement", type: .framework),
            ],
            settings: .settings(
                base: [
                    "CLANG_ENABLE_MODULES": "YES",
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
