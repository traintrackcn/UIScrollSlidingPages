Pod::Spec.new do |s|
  s.name = 'UIScrollViewSlidingPages'
  s.version = '1.0'
  s.platform = :ios, '5.0'
  s.license = 'MIT'
  s.summary = 'forked from TomThorpe/UIScrollSlidingPages'
  s.homepage = 'https://github.com/traintrackcn/UIScrollSlidingPages'
  
  s.subspec 'Source' do |t|
    t.source_files    = 'UIScrollViewSlidingPages/Source/*.{h,m}'
    t.requires_arc    = true
  end
  
end