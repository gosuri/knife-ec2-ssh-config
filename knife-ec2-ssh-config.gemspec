# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'knife-ec2-ssh-config/version'

Gem::Specification.new do |spec|
  spec.name          = "knife-ec2-ssh-config"
  spec.version       = Knife::Ec2::SshConfig::VERSION
  spec.authors       = ["Greg Osuri"]
  spec.email         = ["greg@overclock.io"]
  spec.description   = %q{Knife plugin to update ssh client config with ec2 instance information}
  spec.summary       = %q{SSH config file generation support for Chef's knife command}
  spec.homepage      = "http://github.com/gosuri/knife-ec2-ssh-config"
  spec.license       = "MIT"

  spec.files         = %w(
    lib/chef/knife/ec2_ssh_config_generate.rb
    lib/knife-ec2-ssh-config/version.rb
  )
  
  spec.require_paths = ["lib"]
  spec.add_dependency 'fog',           '~> 1.20.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
