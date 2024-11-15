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
