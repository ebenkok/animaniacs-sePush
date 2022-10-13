# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'

target 'BlackMap' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for BlackMap
  pod 'shared', :path => 'eskom-se-api-client/shared'
  
  target 'BlackMapTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'BlackMapUITests' do
    # Pods for testing
  end
  
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end

  
end

