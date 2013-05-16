require "puppet-lint"

class CucumberPuppetLint < PuppetLint
  def initialize
    super
    
    @log = Hash.new
  end
  
  def file=(path)
    super
    
    @log[path] = Array.new
  end
  
  def format_message(message)
    format = log_format
    
    @log[@fileinfo[:path]] << format % message
  end
  
  def to_report
    report = ''
    
    @log.keys.sort.each do |path|
      next if @log[path].empty?
      
      report += "#{path}:\n  " + @log[path].join("\n  ") + "\n\n"
    end
    
    report
  end
end

CucumberPuppetLint.configuration.fail_on_warnings = false
CucumberPuppetLint.configuration.error_level = :all
CucumberPuppetLint.configuration.with_filename = false
CucumberPuppetLint.configuration.log_format = ''

Given /^any manifest$/ do
end

Then /^it should validate$/ do
  manifests = Dir.glob('**/*.pp')

  system("puppet parser validate #{manifests.to_a.join(' ')}").should be_true
end

Then /^it should have no lint errors$/ do
  linter = CucumberPuppetLint.new
  manifests = Dir.glob('**/*.pp')
  
  log = Hash.new
  
  manifests.each do |puppet_file|
    linter.file = puppet_file
    linter.run
  end
  
  fail(linter.to_report) if linter.errors?
end

Then /^it should have no lint errors or warnings$/ do
  linter = CucumberPuppetLint.new
  manifests = Dir.glob('**/*.pp')

  manifests.each do |puppet_file|
    linter.file = puppet_file
    linter.run
  end
  
  fail(linter.to_report) if linter.errors? || linter.warnings?
end