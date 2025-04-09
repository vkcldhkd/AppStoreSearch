# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'AppStoreSearch' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

	pod 'Alamofire'
	pod 'ReactorKit'
	pod 'ReusableKit/RxSwift'
	pod 'RxAlamofire'
	pod 'RxDataSources'
	pod 'RxViewController'
	pod 'RxOptional'
	pod 'RxKingfisher'

	inhibit_all_warnings!
end

target 'AppStoreSearchTests' do
    inherit! :search_paths
    # Pods for testing
	pod 'Alamofire'
	pod 'RxAlamofire'
end


post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
            end
        end
    end
end