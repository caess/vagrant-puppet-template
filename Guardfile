require "fileutils"
require 'pp'

group :puppet, :halt_on_fail => true do
  # Run rspec-puppet tests
  # --format documentation : for better output
  # :spec_paths to pass the correct path to look for features
  guard :rspec, :cli => "--color --format documentation", :spec_paths => ["puppet-repo"]  do
    # Match any .pp file (but be carefull not include and dot-temporary files)
    watch(%r{^puppet-repo/.*/[^.]*\.pp$}) { "puppet-repo" }
    # Match any .rb file (but be carefull not include and dot-temporary files)
    watch(%r{^puppet-repo/.*/[^.]*\.rb$}) { "puppet-repo" }
    # Match any _rspec.rb file (but be carefull not include and dot-temporary files)
    watch(%r{^puppet-repo/.*/[^.]*_rspec.rb})
  end

  # Run cucumber puppet tests
  # This uses out extended cucumber guard, as by default it only looks in the features directory
  # --strict        : because otherwise cucumber would exit with 0 when there are pending steps
  # --format pretty : to get readable output, default is null output
  guard :cucumber, :feature_sets => ["puppet-repo/features"], :cli => "-s --require puppet-repo/features --strict --format pretty" do

    # Match any .pp file (but be carefull not include and dot-temporary files)
    watch(%r{^puppet-repo/[^.]*\.pp$}) { "puppet-repo/features" }

    # Match any .rb file (but be carefull not include and dot-temporary files)
    watch(%r{^puppet-repo/[^.]*\.rb$}) { "puppet-repo/features" }

    # Feature files are monitored as well
    watch(%r{^puppet-repo/features/[^.]*.feature})
  end

  guard :shell, :all_on_start => true do
    watch(%r{^Vagrantfile$}) do
      success = system('vagrant reload')
      if success
        n 'VM(s) loaded', 'Vagrant', :success
        'VM(s) loaded'
      else
        n 'VM(s) failed to load', 'Vagrant', :failed
        'VM(s) failed to load'
      end
    end
  end

  guard :shell do
    watch(%r{^puppet-repo/(manifests|modules)(/[^./][^/]*)*/[^./][^/]*$}) do
      msg = ''
      success = system('vagrant provision')
      if success
        FileUtils.touch('.vagrant_last_provisioned')

        n 'VM(s) provisioned', 'Vagrant', :success
        'VM(s) provisioned'
      else
        n 'VM(s) failed provisioning', 'Vagrant', :failed
        'VM(s) failed provisioning'
      end
    end
  end
end

group :vagrant do
  # Run cucumber tests on the VM(s)
  guard :cucumber, :cli => "-s --strict --format progress" do
    # Match any .rb file (but be careful not include and dot-temporary files)
    watch(%r{^features/[^.]*\.rb$}) { "features" }

    # Feature files are monitored as well
    watch(%r{^features/[^.]*.feature})

    # Watch to see if the VM(s) have been reprovisioned
    watch('.vagrant_last_provisioned') { "features" }
  end
end
