Pod::Spec.new do |s|
    
  s.name             = 'SCSegmentControl'
  s.version          = '1.0.0'
  s.summary          = 'A short description of SCSegmentControl.'
  s.homepage         = 'https://github.com/Samueler/SCSegmentControl.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Samueler.Chen' => 'samueler.chen@gmail.com' }
  s.source           = { :git => 'https://github.com/Samueler/SCSegmentControl.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'SCSegmentControl/Classes/**/*'
  
end
