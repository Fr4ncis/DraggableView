Pod::Spec.new do |s|
  s.name  = "DraggableView"
  s.version = "0.0.2"
  s.summary = "A Tinder-like draggable view that over a certain threshold animates out of the screen."
  s.homepage = "https://github.com/Fr4ncis/DraggableView.git"
  # s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license = 'MIT'
  s.author = { "Francesco Mattia" => "francesco.mattia@gmail.com" }
  s.social_media_url = "http://twitter.com/francescomattia"
  s.platform  = :ios, '6.0'
  s.requires_arc = true
  s.source  = { :git => "https://github.com/Fr4ncis/DraggableView.git", :tag => "0.0.2" }
  s.source_files  = 'DraggableView', 'DraggableView/**/*.{h,m}'
end
