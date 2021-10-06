# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'
use_frameworks!

target 'Printing-Log-3D' do
    pod 'Firebase/Core'
    pod 'Firebase/Storage'
    pod 'Firebase/Firestore'
    pod 'Firebase/Auth'
    pod 'FirebaseUI/Google'
    pod 'GoogleSignIn'
    pod 'SDWebImage', '~> 5.0'
    
end
post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
  end
 end
end
