require 'yaml'
require 'logger'
require 'date'

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

	@packages = []

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
		puts @packages.inspect
	end

	def self.determine_recent_installs
		begin
			recent_logfile = IO.read(config[:unattended_upgrades_log])
		rescue
			log(:fatal, "Unable to open unattended upgrades log. Cannot determine recently installed packages.")
			return nil
		end

		begin
			statefile = IO.read(config[:state_file])
		rescue
			statefile = "1990-01-01"
			IO.write(config[:state_file], statefile)
		end

		recent_logfile.each_line do |line|
			date = DateTime.parse(line)
			if date > DateTime.parse(statefile)
				if /Packages that are upgraded: /.match(line)
					# these are the lines containing package names
					matches = /(?::\ ).+$/.match(line)
					these_packages = matches[0].split(" ")
					these_packages = these_packages[1..these_packages.length]
					these_packages.each do |package|
						@packages << package
					end
				end
			end
		end	

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

