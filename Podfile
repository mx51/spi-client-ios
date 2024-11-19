platform :ios, '15.6'
inhibit_all_warnings!

source 'https://github.com/CocoaPods/Specs.git'

def import_pods
    pod 'RNCryptor-objc'
    pod 'SocketRocket'
end

target 'SPIClient-iOS' do
    import_pods    
end

target 'Tests' do
    inherit! :search_paths
    import_pods
end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.6'
  end
 end
end
