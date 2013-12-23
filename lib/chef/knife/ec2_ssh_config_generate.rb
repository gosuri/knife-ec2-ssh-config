require 'chef/knife'

class Chef
  class Knife
    class Ec2SshConfigGenerate < Knife
      include FileUtils
      SSH_CONFIG_FILE = "#{ENV['HOME']}/.ssh/config"
      GEN_WARNING    = "### This block is auto generated using knife ec2 ssh generate ###"
      BEGIN_MARKER = "### Knife EC2 ssh hosts - begin ###"
      END_MARKER   = "### Knife EC2 ssh hosts - end ###"

      deps do
        require 'fog'
      end

      banner "knife ec2 ssh generate (options)"

      option :aws_credential_file,
        :long => "--aws-credential-file FILE",
        :description => "File containing AWS credentials as used by aws cmdline tools",
        :proc => Proc.new { |key| Chef::Config[:knife][:aws_credential_file] = key }

      option :aws_access_key_id,
        :short => "-A ID",
        :long => "--aws-access-key-id KEY",
        :description => "Your AWS Access Key ID",
        :proc => Proc.new { |key| Chef::Config[:knife][:aws_access_key_id] = key }

      option :aws_secret_access_key,
        :short => "-K SECRET",
        :long => "--aws-secret-access-key SECRET",
        :description => "Your AWS API Secret Access Key",
        :proc => Proc.new { |key| Chef::Config[:knife][:aws_secret_access_key] = key }

      option :identity_file,
        :short => "-i IDENTITY_FILE",
        :long => "--identity-file IDENTITY_FILE",
        :description => "The SSH identity file used for authentication"

      option :ssh_user,
        :short => "-x USERNAME",
        :long => "--ssh-user USERNAME",
        :description => "The ssh username",
        :default => "root"

      def run
        $stdout.sync = true
        backup_ssh_file
        remove_old_config
        write_config
      end

      private

      def write_config
        open(SSH_CONFIG_FILE, "a") do | f |
          f.puts ""
          f.puts BEGIN_MARKER
          f.puts GEN_WARNING
          f.puts ""
          servers.each do |name, host|
            if namespace = locate_config_value(:ec2_ssh_namespace)
              f.puts "Host #{namespace}-#{name}" 
            else
              f.puts "Host #{name}"
            end
            f.puts "  HostName #{host}"
            if user = locate_config_value(:ssh_user)
              f.puts "  User #{user}"
            end
            if identity = locate_config_value(:identity_file)
              f.puts "  IdentityFile #{File.expand_path(identity)}"
            end
            f.puts ""
          end
          f.puts END_MARKER
          f.puts ""
        end
      end

      def remove_old_config
        content = open(SSH_CONFIG_FILE).read
        content.slice! /#{BEGIN_MARKER}\n*.*\n#{END_MARKER}/mi
        open(SSH_CONFIG_FILE, "w").write(content.strip)
      end

      def servers
        unless @servers
          @servers = {}
          connection.servers.all.each do |server|
            @servers[server.tags['Name']] = server.dns_name
          end
        end
        @servers
      end

      def backup_ssh_file
        ssh_backup_file = "#{SSH_CONFIG_FILE}-knife-#{Time.now.to_i}"
        copy_file SSH_CONFIG_FILE, ssh_backup_file
        ui.info "Backed up ssh config file to #{ssh_backup_file}"
      end

      def connection
        @connection ||= begin
                          connection = Fog::Compute.new(
                            :provider => 'AWS',
                            :aws_access_key_id => Chef::Config[:knife][:aws_access_key_id],
                            :aws_secret_access_key => Chef::Config[:knife][:aws_secret_access_key],
                            :region => locate_config_value(:region)
                          )
                        end
      end

      def locate_config_value(key)
        key = key.to_sym
        config[key] || Chef::Config[:knife][key]
      end
    end
  end
end
