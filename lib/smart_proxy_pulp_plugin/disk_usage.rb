module PulpProxy
  class DiskUsage
    include ::Proxy::Util
    include ::Proxy::Log
    SIZE = { :kilobyte => 1_024, :megabyte => 1_048_576, :gigabyte => 1_073_741_824, :terabyte => 1_099_511_627_776 }

    attr_reader :path, :stat, :size

    def initialize(opts ={})
      raise(::Proxy::Error::ConfigurationError, 'Unable to continue - must provide a path.') if opts[:path].nil?
      @paths_hash = validate_path(path_hash(opts[:path]))
      @path = @paths_hash.values
      @size_format = opts[:size] || :kilobyte
      @size = SIZE[@size_format]
      @stat = {}
      find_df
      get_stat
    end

    def to_json
      stat.to_json
    end

    private

    attr_reader :command_path

    def find_df
      @command_path = which('df') || raise(::Proxy::Error::ConfigurationError, 'df command was not found unable to retrieve usage information.')
    end

    def command
      [command_path, "-P", "-B", "#{size}", *path]
    end

    # Inspired and copied from Facter
    # @ https://github.com/puppetlabs/facter/blob/2.x/lib/facter/core/execution/base.rb
    # @TODO: Refactor http://projects.theforeman.org/issues/15235 when removing support for 1.8.7
    def with_env(values)
      old = {}
      values.each do |var, value|
        # save the old value if it exists
        if old_val = ENV[var]
          old[var] = old_val
        end
        # set the new (temporary) value for the environment variable
        ENV[var] = value
      end
      # execute the caller's block, capture the return value
      rv = yield
        # use an ensure block to make absolutely sure we restore the variables
    ensure
      # restore the old values
      values.each do |var, value|
        if old.include?(var)
          ENV[var] = old[var]
        else
          # if there was no old value, delete the key from the current environment variables hash
          ENV.delete(var)
        end
      end
      # return the captured return value
      rv
    end

    def get_stat
      with_env 'LC_ALL' => 'C' do
        raw = Open3::popen3(*command) do |stdin, stdout, stderr, thread|
          unless stderr.read.empty?
            error_line = stderr.read
            logger.error "[#{command_path}] #{error_line}"
            raise(::Proxy::Error::ConfigurationError, "#{command_path} raised an error: #{error_line}")
          end
          stdout.read.split("\n")
        end

        logger.debug "[#{command_path}] #{raw.to_s}"

        titles = normalize_titles(raw)
        raw.each_with_index do |line, index|
          mount_path = path[index]
          values = normalize_values(line.split)
          @stat[hash_key_for(mount_path)] = Hash[titles.zip(values)].merge({:path => mount_path, :size => @size_format})
        end
      end
    end

    def path_hash(path)
      path.is_a?(Hash) ? path : Hash[path, path]
    end

    def hash_key_for(path)
      @paths_hash.select { |k,v| v == path}.first[0]
    end


    def normalize_titles(raw)
      replacers = {"mounted on" => :mounted, "use%" => :percent}
      raw.shift.downcase.gsub(/(use%|mounted on)/) { |m| replacers.fetch(m,m)}.split.map(&:to_sym)
    end

    def normalize_values(values)
      values.each_with_index do |value, index|
        is_int = Integer(value) rescue false
        values[index] = is_int if is_int
      end
      values
    end

    def validate_path(path_hash)
      path_hash.each do |key, value|
        unless File.readable?(value)
          logger.warn "File at #{value} defined in #{key} parameter doesn't exist or is unreadable"
          path_hash.delete(key)
        end
      end
      path_hash
    end
  end
end
