# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'Desafio_Carros' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Desafio_Carros
  pod 'Alamofire', '~> 4.0'
  pod 'AlamofireImage'
  pod 'ObjectMapper', '~> 2.2'
  pod 'PromiseKit'
  pod 'RealmSwift'
  pod 'SDWebImage'

  target 'Desafio_CarrosTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Desafio_CarrosUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
