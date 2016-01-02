Pod::Spec.new do |s|

  s.name         		      = "Djaft"
  s.version      		      = "0.1.1"
  s.summary      		      = "A Django-syntax CoreData-wrapper."

  s.description  		      = <<-DESC
  						              No more hassle with NSFetchRequests, NSPredicates and NSSortDescriptors!
                   		      DESC

  s.homepage    		      = "https://github.com/JanNash/Djaft"
  s.license      		      = { :type => "MIT", :file => "LICENSE" }
  s.authors               = { "Jan Nash" => "jnash@jnash.de" }
  s.social_media_url      = "http://twitter.com/JanPNash"
  s.platform    		      = :ios, "8.0"
  s.source       		      = { :git => "https://github.com/JanNash/Djaft.git", :tag => "v#{s.version}" }
  s.source_files  		    = "Djaft/Sources/*/*.swift"
  s.public_header_files   = []
  s.dependency 			      'Synchronized'
  
end
