Pod::Spec.new do |s|

  s.name         		= "Swango"
  s.version      		= "0.1.1"
  s.summary      		= "A Django-syntax CoreData-wrapper. No more messaround with NSPredicates and NSSortDescriptors!"

  s.description  		= <<-DESC
                   		A longer description of Swango in Markdown format.

                   		* Think: Why did you write this? What is the focus? What does it do?
                   		* CocoaPods will be using this to generate tags, and improve search results.
                   		* Try to keep it short, snappy and to the point.
                   		* Finally, don't worry about the indent, CocoaPods strips it!
                   		DESC

  s.homepage    		 = "https://github.com/JanNash/Swango"
  s.license      		= { :type => "MIT" }
  s.authors            	= { "Jan Nash" => "jnash@jnash.de" }
  s.social_media_url   	= "http://twitter.com/JanPNash"
  s.platform    		= :ios, "8.0"
  s.source       		= { :git => "https://github.com/JanNash/Swango.git", :tag => "v#{s.version}" }
  s.source_files  		= "Swango/Sources/*/*.swift"
  s.public_header_files = []
  s.dependency 			'Synchronized'

end
