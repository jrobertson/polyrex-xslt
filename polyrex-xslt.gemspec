Gem::Specification.new do |s|
  s.name = 'polyrex-xslt'
  s.version = '0.2.0'
  s.summary = 'Generates XSLT to produce a Polyrex document from a tree-like XML structure.'
    s.authors = ['James Robertson']
  s.files = Dir['lib/polyrex-xslt.rb'] 
  s.add_runtime_dependency('rexle', '~> 1.5', '>=1.5.2')  
  s.signing_key = '../privatekeys/polyrex-xslt.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/polyrex-xslt'
  s.required_ruby_version = '>= 2.1.2'
end
