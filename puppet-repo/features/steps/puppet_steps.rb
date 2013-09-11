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
  load_config if not @config

  @manifests = Dir.glob('**/*.pp').to_a.reject {|filename| filename =~ %r{/modules/} and filename !~ %r{/modules/#{@config['module_prefix']}-}}
end

Then /^it should validate$/ do
  system("puppet parser validate #{@manifests.join(' ')}").should be_true
end

Then /^it should have no lint errors$/ do
  linter = CucumberPuppetLint.new

  log = Hash.new

  @manifests.each do |puppet_file|
    linter.file = puppet_file
    linter.run
  end

  fail(linter.to_report) if linter.errors?
end

Then /^it should have no lint errors or warnings$/ do
  linter = CucumberPuppetLint.new

  @manifests.each do |puppet_file|
    linter.file = puppet_file
    linter.run
  end

  fail(linter.to_report) if linter.errors? || linter.warnings?
end