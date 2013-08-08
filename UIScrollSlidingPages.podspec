Pod::Spec.new do |s|
  s.name = 'UIScrollSlidingPages'
  s.version = '1.0'
  s.platform = :ios, '5.0'
  s.license = 'MIT'
  s.summary = 'forked from TomThorpe/UIScrollSlidingPages'
  s.homepage = 'https://github.com/traintrackcn/UIScrollSlidingPages'
  s.authors = { 'traintrackcn' => 'traintrackcn@gmail.com'}
  
  s.subspec 'Source' do |ss|
    ss.source_files    = 'UIScrollViewSlidingPages/Source/*.{h,m}'
    ss.requires_arc    = true
  end
  
end