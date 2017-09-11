module Utils
  class << self
    def db_files
      Dir.entries('./db').reject {|filename| filename == '.' || filename == '..'}
    end
  end
end