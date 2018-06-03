
Pod::Spec.new do |s|

  s.version       = "1.0.1"

  s.swift_version = '4.0'

  s.name          = "XLsn0wConstraintLayout"
  s.homepage      = "https://github.com/XLsn0w/XLsn0wAutoLayout"
  s.source        = { :git => "https://github.com/XLsn0w/XLsn0wAutoLayout.git", :tag => s.version.to_s }

  s.summary       = "iOS make Constraints Layout Kit"

  s.author        = { "XLsn0w" => "xlsn0w@outlook.com" }
  s.license       = 'MIT'
  s.platform      = :ios, "8.0"
  s.requires_arc  = true

  s.source_files  = "XLsn0wConstraintLayout/**/*.{h,m}"

  s.frameworks    = 'UIKit', 'Foundation'

end
