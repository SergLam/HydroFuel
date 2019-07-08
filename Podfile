platform :ios, '11.0'

inhibit_all_warnings!

target 'HydroFuel' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for HydroFuel
    pod 'SlideMenuControllerSwift', '~> 4.0.0'
    pod 'UICircularProgressRing', '~> 6.2.0'
    pod 'FSCalendar', '~> 2.8.0'
    pod 'Charts', '~> 3.3.0'
    pod 'IQKeyboardManagerSwift', '~> 6.4.0'
    pod 'iShowcase', '~> 2.3.0'
    pod 'CTShowcase', '~> 2.4.0'
    pod 'SVProgressHUD', '~> 2.2.5'
    pod 'R.swift', '~> 5.0.3'
    
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
end
    
end
