platform :ios, '9.0'

target 'ToDo' do
  use_frameworks!

  # Pods for ToDo
  pod 'RealmSwift'

  target 'ToDoTests' do
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