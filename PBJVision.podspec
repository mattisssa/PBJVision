Pod::Spec.new do |s|
  s.name = 'PBJVisionCC'
  s.version = '1.0.0'
  s.summary = 'iOS camera engine, supports touch-to-record video, slow motion video, and photo capture.'
  s.homepage  = 'git@github.com:capturetechnologies/PBJVision'
  s.social_media_url = 'http://twitter.com/piemonte'
  s.license = 'MIT'
  s.authors = { 'patrick piemonte' => 'piemonte@alumni.cmu.edu' }
  s.source    = { :git => s.homepage + '.git', :tag => 'v' + s.version.to_s }
  s.frameworks = 'Foundation', 'AVFoundation', 'CoreGraphics', 'CoreMedia', 'CoreVideo', 'CoreImage', 'MobileCoreServices', 'ImageIO', 'QuartzCore', 'OpenGLES', 'UIKit'
  s.platform = :ios, '9.0'
  s.source_files = 'Source'
  s.resources = 'Source/Shaders/*'
  s.requires_arc = true
end
