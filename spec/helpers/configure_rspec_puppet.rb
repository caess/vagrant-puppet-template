require 'rubygems'
require 'facter'
require 'puppetlabs_spec_helper/module_spec_helper'

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', ENV['X_MODULE_PATH'], '/lib'))) if ENV['X_MODULE_PATH']

RSpec.configure do |c|
  c.module_path = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'puppet-repo', 'modules'))
  c.manifest_dir = File.expand_path(File.join(File.dirname(__FILE__), 'manifests'))
end

