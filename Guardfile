require "fileutils"

module_prefix = 'caess'
vms_to_sandbox = %w{}

group :puppet, :halt_on_fail => true do
  # Enumerate the Puppet modules and set up rspec guards for them.
  Dir.glob("puppet-repo/modules/#{module_prefix}-*/spec/").each do |spec_path|
    spec_path =~ %r{^(puppet-repo/modules/[^/]+)/spec}
    mod_path = $1

    # If we use puppet module to create a module directory, it will be set up
    # as <author>-<name> which we then symlink to <name>.  We want to skip
    # any symlinks so we don't run the tests multiple times.
    next if File.symlink?(mod_path)

    # Set up rspec guards for the modules.
    #
    # Set X_MODULE_PATH so configure_rspec_puppet.rb can add the path to
    # $LOAD_PATH for custom facts
    guard :rspec, :cli => "-I #{spec_path} -I #{mod_path}/lib --require #{Dir.pwd}/spec/helpers/configure_rspec_puppet.rb --color --format documentation",
        :env => {'X_MODULE_PATH' => mod_path}, :spec_paths => [spec_path],
        :all_on_start => true do
      # Watch Puppet manifest files, skipping temporary dot-files
      watch(%r{^#{mod_path}/manifests/(?:.*/)?[^.].*\.pp$}) {spec_path}

      # Watch Ruby lib files, skipping temporary dot-files
      watch(%r{^#{mod_path}/lib/.*/[^.].*\.rb$}) {spec_path}

      # Watch module files, skipping temporary dot-files
      watch(%r{^#{mod_path}/files/(?:.*/)?[^.]}) {spec_path}

      # Watch template erb files, skipping temporary dot-files
      watch(%r{^#{mod_path}/templates/(?:.*/)?[^.].*\.erb$}) {spec_path}

      # Match any _spec.rb file, skipping temporary dot-files
      watch(%r{^#{mod_path}/spec/(?:.*/)?[^.].*_spec.rb$})

      # Match spec_helper.rb files
      watch(%r{^#{mod_path}/spec/spec_helper.rb$}) {spec_path}

      # Watch configure_rspec_puppet.rb
      watch(%r{spec/helpers/configure_rspec_puppet.rb$}) {spec_path}

      # Watch manifest fixtures
      watch(%r{spec/helpers/manifests/[^.]+\.pp$}) {spec_path}
    end
  end

  # Run the cucumber-based Puppet tests.
  guard :cucumber, :feature_sets => ["puppet-repo/features"], :cli => "-s --require puppet-repo/features --strict --format pretty" do
    # Watch the cucumber feature files, skipping temporary dot-files
    watch(%r{^puppet-repo/features/[^.]*.feature$})

    # Watch Puppet manifest files, skipping temporary dot-files
    watch(%r{^puppet-repo/[^.]*\.pp$}) {"puppet-repo/features"}

    # Watch Ruby lib files, skipping temporary dot-files
    watch(%r{^puppet-repo/modules/[^/]+/lib/.*/[^.].*\.rb$}) {"puppet-repo/features"}

    # Watch module files, skipping temporary dot-files
    watch(%r{^puppet-repo/modules/[^/]+/files/(?:.*/)?[^.]}) {"puppet-repo/features"}

    # Watch template erb files, skipping temporary dot-files
    watch(%r{^puppet-repo/modules/[^/]+/templates/(?:.*/)?[^.].*\.erb$}) {"puppet-repo/features"}
  end

  # Reload the VMs if Vagrantfile is changed.
  guard :shell, :all_on_start => true do
    watch(%r{^Vagrantfile$}) do
      failures = []

      IO.popen('vagrant status').each do |line|
        if line =~ /^(\S+)\s+(not created|poweroff|running)/
          vm    = $1
          state = $2

          case state
          when 'not created', 'poweroff'
            command = 'up'
            text = 'load'
          when 'running'
            command = 'reload'
            text = 'reload'
          end

          success = system("vagrant #{command} #{vm}")
          failures << "#{vm} load" if not success
        end
      end

      # Enabling sandboxing for sandboxed VMs.
      IO.open('vagrant sandbox status').each do |line|
        if line =~ /\[([^\]]+)\] Sandbox mode is off$/
          vm = $1
          if vms_to_sandbox.include?(vm)
            success = system("vagrant sandbox on #{vm}")
            failures << "#{vm} sandbox" if not sucess
          end
        end
      end

      if failures.empty?
        n 'VM(s) loaded', 'vagrant', :success
        'VM(s) loaded'
      else
        n 'VM(s) errors: ' + failures.join(', '), 'vagrant', :failed
        'VM(s) errors: ' + failures.join(', ')
      end
    end
  end

  # Collect any Puppet changes and touch .vagrant_needs_provision once if there
  # are any changes.  This is done to prevent reprovisioning the VMs multiple
  # times.
  guard :shell do
    watch(%r{^puppet-repo/(manifests|modules)(/[^./][^/]*)*/[^./][^/]*$}) do
      FileUtils.touch('.vagrant_needs_provision')
      ''
    end
  end

  # Reprovision the VMs.  If successful, touch .vagrant_last_provisioned to
  # let guard know to run the cucumber features for the system.
  guard :shell do
    watch(%r{^.vagrant_needs_provision$}) do
      msg = ''
      success = system('vagrant provision')
      if success
        # We need to commit the sandboxed VMs.
        system("vagrant sandbox commit")

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
  # Run the cucumber features for the system.
  guard :cucumber, :cli => "-s --strict --format progress" do
    # Watch to see if the VM(s) have been reprovisioned
    watch('.vagrant_last_provisioned') {"features"}

    # Monitor the feature files.
    watch(%r{^features/[^.]*.feature})

    # Monitor the step definitions or support files used by the cucumber
    # features.
    watch(%r{^features/[^.]*\.rb$}) {"features"}
  end
end
