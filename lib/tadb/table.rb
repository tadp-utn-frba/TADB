require 'securerandom'
require 'json'

class TADB::Table

  def initialize(name)
    @name = name
  end

  def entries
    file('r') do |f|
      f.readlines.map do |line|
        JSON.parse(line).map {|k, v| [k.to_sym, v]}.to_h
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
    File.open(db_path, 'w') {}
  end

  private

  def file(mode, &block)
    Dir.mkdir('./db') unless File.exists?('./db')
    clear unless File.exists?(db_path)

    File.open(db_path, mode) {|file| block.call(file)}
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
