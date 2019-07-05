platform :ios, '11.0'

inhibit_all_warnings!

target 'HydroFuel' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for HydroFuel
    pod 'SlideMenuControllerSwift'
    pod 'UICircularProgressRing'
    pod 'FSCalendar'
    pod 'Charts'
    pod 'IQKeyboardManagerSwift'
    pod 'iShowcase'
    pod 'CTShowcase'
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
end
    
end
