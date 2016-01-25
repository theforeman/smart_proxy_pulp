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
      @size = SIZE[opts[:size]] || SIZE[:kilobyte]
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
      [command_path, "-B", "#{size}", *path]
    end

    def get_stat
      raw = Open3::popen3({"LC_ALL" => "C"}, *command) do |stdin, stdout, stderr, thread|
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
        @stat[@paths_hash.key(mount_path)] = Hash[titles.zip(values)].merge({:path => mount_path, :size => SIZE.key(size)})
      end
    end

    def path_hash(path)
      path.is_a?(Hash) ? path : Hash[path, path]
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
