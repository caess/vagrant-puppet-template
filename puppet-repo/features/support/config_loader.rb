require 'yaml'

module ConfigLoader
  def load_config
    # Load the environment configuration
    @config = YAML.load_file(File.join(File.dirname(__FILE__), '..', '..', '..', 'config.yml'))
  end
end

World(ConfigLoader)