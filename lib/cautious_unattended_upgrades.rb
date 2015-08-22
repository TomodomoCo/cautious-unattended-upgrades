require 'yaml'
require 'logger'
require 'date'
require 'open3'

class Cautious_unattended_upgrades

	# Configuration defaults
	@config = {
		:log_level               => "verbose",
		:log_file                => "/var/log/cautious_unattended_upgrades/cautious_unattended_upgrades.log",
		:unattended_upgrades_log => "/var/log/unattended-upgrades/unattended-upgrades.log",
		:state_file              => "/var/lib/cautious_unattended_upgrades/cautious_unattended_upgrades.state",
		:tests_directory         => "/var/lib/cautious_unattended_upgrades/tests",
		:ssh_identity            => "/root/.ssh/id_rsa",
		:clients                 => [],
	}

	@valid_config_keys = @config.keys

	@packages = []

	@did_fail = true # for safety

	@failures = []

	def self.configure(opts = {})
		opts.each {
			|k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym
		}

	end

	def self.log(level = Logger::DEBUG, message)
		@logger = Logger.new(@config[:log_file], File::WRONLY | File::APPEND)
		@logger.add(level, message, "cautious-unattended-upgrades")
		puts message
	end

	def self.configure_with(yaml_path)
		local_logger = Logger.new(STDERR)
		begin
		config = YAML::load(IO.read(path_to_yaml_file))
		rescue Errno::ENOENT
			local_logger.add(Logger::WARN, "YAML configuration file couldn't be found. Using defaults."); return
		rescue Psych::SyntaxError
			local_logger.add(Logger::WARN, "YAML configuration file contains invalid syntax. Using defaults."); return
		end		

		configure(config)
	end

	def self.run_tests

		@did_fail = false

		if Dir[@config[:tests_directory] + "/*.rb"].length == 0
			log(:fatal, "Did not find any tests to run in '#{@config[:tests_directory]}'. Is this directory configured properly?")
			false
		end

		Dir[@config[:tests_directory] + "/*.rb"].each do |test|
			begin
				require test
			rescue StandardError => e
				log(Logger::WARN, "Test '#{test}' failed with '#{e}'")
				@failures << { test => e }
				@did_fail = true
			end
		end

	end

	def self.maybe_push_upgrades
		unless @did_fail

			# let's push upgrades

			if @packages.length < 1
				log(Logger::INFO, "No new package upgrades to push.")
				return
			end

			formatted_whitelist = ''

			@packages.each do |package|
				formatted_whitelist += "\\\"#{package}\\\"; "
			end

			sed_cmd = "sed -i -e 's/Package-Whitelist\s{\\([^}]\\+\\)}/Package-Whitelist { #{formatted_whitelist} }/g' /etc/apt/apt.conf.d/50unattended-upgrades"

			@config[:clients].each do |client|
				log(Logger::INFO, "Pushing package upgrade whitelist to #{client["user"]}@#{client["ip"]}:#{client["ssh_port"]}")

				# as escaped for shell
				# $ sed -e 's/Package-Whitelist {\([^}]\+\)}/Package-Whitelist { \"firefox-locale-en\"; \"tzdata\"; \"openssh-client\"; \"openssh-server\"; \"ssh\"; \"libsnmp-base\"; \"libsnmp15\"; \"linux-image-virtual\"; \"linux-libc-dev\"; \"snmp\"; \"snmpd\"; \"openssh-client\"; \"openssh-server\"; \"ssh\";  }/g' /etc/apt/apt.conf.d/50unattended-upgrades
				output, err, status = Open3.capture3("ssh -i #{@config[:ssh_identity]} -p #{client["ssh_port"]} -l #{client["user"]} #{client["ip"]} \"#{sed_cmd}\"")	
				unless status.success? 
					log(Logger::ERROR, "Package upgrade push for #{client["user"]}@#{client["ip"]}:#{client["ssh_port"]} failed with #{status}.")
					log(Logger::DEBUG, output)
					log(Logger::DEBUG, err);
				end
				
			end

		else
			log(Logger::WARN, "Will not push upgrades to clients, as one or more tests failed, or no tests have been run.")
		end
	end

	def self.dumpy_dump
		puts @failures
		puts @did_fail
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

