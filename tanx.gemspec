# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tanx/version'

Gem::Specification.new do |spec|
  spec.name          = "tanx"
  spec.version       = "0.0.1"
  spec.authors       = ["Partho Ghosh"]
  spec.email         = ["partho.ghosh24@gmail.com"]

  spec.summary       = %q{Tanx - Fast paced tanks action}
  spec.description   = %q{Tanx is a fast paced action shooter. Built it while learning game development from "Developing games with Ruby" using Gosu Library.}
  spec.homepage      = "https://github.com/parthoghosh24/tanx"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "gosu", ">= 0.9.0"
  spec.add_dependency "gosu_texture_packer"
  spec.add_dependency "ruby-prof"
  spec.add_dependency "rmagick"
  spec.add_dependency "gosu_tiled"
  spec.add_dependency "perlin_noise"
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end
