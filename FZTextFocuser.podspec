Pod::Spec.new do |s|
  s.name             = 'FZTextFocuser'
  s.version          = '0.1.0'
  s.summary          = 'A class meant to simplify the task of displaying focusable text in tvOS.'

  s.description      = <<-DESC
FZTextFocuser allows focusable text to be displayed in tvOS. The user can choose to highlight the entire text or just parts of it. Please see the README file for more details.
                       DESC

  s.homepage         = 'https://github.com/gutenbergn/FZTextFocuser'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gutenbergn' => 'gutenbergn@gmail.com' }
  s.source           = { :git => 'https://github.com/gutenbergn/FZTextFocuser.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/gutenbergn'

  s.swift_version = '5.0'
  s.tvos.deployment_target = '9.0'

  s.frameworks = 'UIKit','CoreText'

  s.source_files = 'FZTextFocuser/Classes/**/*'

  s.dependency 'FuzeUtils'
end
