inhibit_all_warnings!

platform :osx, '10.11'

target 'Allkdic' do
  use_frameworks!

  pod 'SimpleCocoaAnalytics',
    :git => 'https://github.com/stephenlind/SimpleCocoaGoogleAnalytics',
    :tag => '0.1.0'

  pod 'SnapKit'
  pod 'Pure'
  pod 'SafeCollection'

  target 'AllkdicTests' do
    inherit! :search_paths

    pod 'Quick'
    pod 'Nimble'
    pod 'Stubber'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.11'
    end
  end
end
