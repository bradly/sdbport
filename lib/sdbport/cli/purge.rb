module Sdbport
  class CLI
    class Purge

      def initialize
        @config = Config.new
      end

      def purge
        opts       = read_options
        access_key = @config.access_key opts[:account]
        secret_key = @config.secret_key opts[:account]
        access_key = opts[:access_key] if opts[:access_key]
        secret_key = opts[:secret_key] if opts[:secret_key]

        logger = SdbportLogger.new :log_level => opts[:level]
        domain = Domain.new :name       => opts[:name],
                            :region     => opts[:region],
                            :access_key => access_key,
                            :secret_key => secret_key,
                            :logger     => logger
        exit 1 unless domain.purge
      end

      def read_options
        Trollop::options do
          version Sdbport::VERSION
          banner <<-EOS

Purge all entries from a SimpleDB domain.

Usage:

sdbport purge -a xxx -k yyy -r us-west-1 -n domain

EOS
          opt :help, "Display Help"
          opt :account, "Account Credentials", :type    => :string,
                                               :default => 'default'
          opt :level, "Log Level", :type => :string, :default => 'info'
          opt :name, "Simple DB Domain Name", :type => :string
          opt :region, "AWS Region", :type => :string
          opt :access_key, "AWS Access Key ID", :type => :string,
                                                :short => 'k'
          opt :secret_key, "AWS Secret Access Key", :type => :string
        end
      end
    end
  end
end
