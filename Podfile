source 'https://cdn.cocoapods.org/'
platform :osx, '14.0'

target 'Allkdic' do
  use_frameworks!

  pod 'SnapKit', '~> 5.7'

  target 'AllkdicTests' do
    inherit! :search_paths
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '14.0'
      if target.name == 'SnapKit'
        config.build_settings['SWIFT_VERSION'] = '5.0'
      else
        config.build_settings['SWIFT_VERSION'] = '6.0'
      end
    end
  end
end
