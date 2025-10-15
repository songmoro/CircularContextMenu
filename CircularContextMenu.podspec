Pod::Spec.new do |s|
  s.name             = 'CircularContextMenu'
  s.version          = '0.1.0'
  s.summary          = 'Customizable circular context menu for iOS'
  s.description      = <<-DESC
                       A customizable circular context menu library for iOS applications.
                       Supports both long-press and tap gestures with smooth animations
                       and flexible configuration options.
                       DESC

  s.homepage         = 'https://github.com/songmoro/CircularContextMenu'
  s.screenshots      = [
    'https://raw.githubusercontent.com/songmoro/CircularContextMenu/main/Screenshots/screenshot1.png',
    'https://raw.githubusercontent.com/songmoro/CircularContextMenu/main/Screenshots/screenshot2.png',
    'https://raw.githubusercontent.com/songmoro/CircularContextMenu/main/Screenshots/screenshot3.png'
  ]
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'songmoro' => 'songmoro@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/songmoro/CircularContextMenu.git', :tag => s.version.to_s }

  s.ios.deployment_target = '16.0'
  s.swift_version = '5.9'

  s.source_files = 'Sources/CircularContextMenu/**/*.swift'

  s.frameworks = 'UIKit'
end
