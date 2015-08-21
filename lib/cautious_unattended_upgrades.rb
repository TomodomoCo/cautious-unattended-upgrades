require 'yaml'
require 'logger'

class Cautious_unattended_upgrades

	# Configuration defaults
	@config = {
		:log_level               => "verbose",
		:log_file                => "/var/log/cautious_unattended_upgrades/cautious_unattended_upgrades.log",
		:unattended_upgrades_log => "/var/log/unattended-upgrades/unattended-upgrades.log",
		:state_file              => "/var/lib/cautious_unattended_upgrades/cautious_unattended_upgrades.state",
		:tests_directory         => "/var/lib/cautious_unattended_upgrades/tests",
		:clients                 => [],
	}

	@valid_config_keys = @config.keys

	@logger = nil

	def self.configure(opts = {})
		opts.each {
			|k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym
		}
	end

	def self.log(level = :debug, message)
		#if @logger == nil:
		#	@logger = Logger.new(@config[log_file], File::APPEND)

		#@logger.info(message)
		puts message
	end

	def self.configure_with(yaml_path)
		begin
		config = YAML::load(IO.read(path_to_yaml_file))
		rescue Errno::ENOENT
			log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
		rescue Psych::SyntaxError
			log(:warning, "YAML configuration file contains invalid syntax. Using defaults."); return
		end		

		configure(config)
	end

	def self.run_tests
	end

	def self.determine_recent_installs

	end


  # Configure through hash
  def self.configure(opts = {})
    opts.each {|k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym}
  end

  # Configure through yaml file
  def self.configure_with(path_to_yaml_file)
    begin
      config = YAML::load(IO.read(path_to_yaml_file))
    rescue Errno::ENOENT
      log(:warning, "YAML configuration file couldn't be found. Using defaults."); return
    rescue Psych::SyntaxError
      log(:warning, "YAML configuration file contains invalid syntax. Using defaults."); return
    end

    configure(config)
  end

  def self.config
    @config
  end

end

