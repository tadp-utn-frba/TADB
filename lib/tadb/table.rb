require 'securerandom'
require 'json'

class TADB::Table

  def initialize(name, clear_if_content = false)
    @name = name
    clear_file_contents if clear_if_content
  end

  def entries
    file('r') do |f|
      f.readlines.map do |line|
        JSON.parse(line, symbolize_names: true)
      end
    end
  end

  def insert(_entry)
    entry = _entry.clone
    entry[:id] ||= SecureRandom.uuid

    validate_types(entry)

    file('a') do |f|
      f.puts(JSON.generate(entry))
    end
    entry[:id]
  end

  def delete(id)
    remaining = entries.reject {|entry| entry[:id] === id}

    file('w') do |f|
      remaining.each do |entry|
        f.puts(JSON.generate(entry))
      end
    end
  end

  def clear
    File.open(db_path, 'w') do |f|
      f.sync = true
    end
  end

  private

  def clear_file_contents
    return unless file_present?
    clear
  end

  def file_present?
    File.file?(db_path)
  end

  def file(mode, &block)
    Dir.mkdir('./db') unless File.exists?('./db')
    clear unless File.exists?(db_path)

    File.open(db_path, mode) do |file|
      # The new File object is buffered mode (or non-sync mode), unless filename is a tty. See IO#flush, IO#fsync, IO#fdatasync, and IO#sync= about sync mode.
      file.sync = true # https://ruby-doc.org/core-3.0.0/File.html#method-c-new-label-Examples
      block.call(file)
    end
  end

  def db_path
    "./db/#{@name}"
  end

  def validate_types(entry)
    invalid_pairs = entry.select do |_, value|
      !value.is_a?(String) && !value.is_a?(Numeric) && value != true && value != false
    end

    unless invalid_pairs.empty?
      separator = '/n/t'
      pairs_description = invalid_pairs
                              .map {|key, value| " #{key}: #{value}"}
                              .join(",#{separator}")
      raise TypeError.new("Can't persist field(s) because they contain non-primitive values at" + separator + pairs_description)
    end
  end
end
