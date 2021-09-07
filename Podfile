# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
deployment_target = '12.0'

install! 'cocoapods', :disable_input_output_paths => true, :warn_for_unused_master_specs_repo => false

use_frameworks!
inhibit_all_warnings!

def all_pods
  
  use_frameworks!
  inhibit_all_warnings!
  
  pod 'SlideMenuControllerSwift', :git => 'https://github.com/mirabo-tech/SlideMenuControllerSwift', :branch => 'master'
  pod 'UICircularProgressRing', '~> 7.0'
  pod 'FSCalendar', '~> 2.8.2'
  pod 'Charts', '~> 3.6.0'
  pod 'IQKeyboardManagerSwift', '~> 6.5.6'
  pod 'iShowcase', :git => 'https://github.com/yramocan/iShowcase', :branch => 'master'
  pod 'CTShowcase', '~> 2.4.0'
  pod 'SVProgressHUD', '~> 2.2.5'
  pod 'R.swift', '~> 5.4.1-alpha.5'
  pod 'RealmSwift', '~> 10.14.0'
  
end

abstract_target 'App' do
  
  target 'HydroFuel' do
    all_pods
  end
  
  post_install do |installer|
    
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
        config.build_settings['ENABLE_BITCODE'] = 'NO' # set 'NO' to disable DSYM uploading - usefull for third-party error logging SDK (like Firebase)
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
      end
    end
    
    installer.generated_projects.each do |project|
      project.build_configurations.each do |bc|
        bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
      end
    end
    
  end
  
end
