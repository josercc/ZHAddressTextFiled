Pod::Spec.new do |s|
  s.name         = 'ZHAddressTextFiled-Objective-C'
  s.version      = '1.0.0'
  s.license      = 'MTC'
  s.homepage     = '<#Homepage URL#>'
  s.authors      = '<#Author Name#>': '<#Author Email#>'
  s.summary      = '<#Summary (Up to 140 characters#>'

  s.platform     =  :ios, '<#iOS Platform#>'
  s.source       =  git: '<#Github Repo URL#>', :tag => s.version
  s.source_files = '<#Resources#>'
  s.frameworks   =  '<#Required Frameworks#>'
  s.requires_arc = true
  
# Pod Dependencies
  s.dependencies =	pod "Masonry"

end
