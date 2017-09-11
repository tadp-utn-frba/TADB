require 'fileutils'
module TADB
  module DB

    def self.table(table_name)
      Table.new(table_name)
    end

    def self.clear_all
      #FileUtils.remove_dir('./db', true)
      Utils.db_files.each do |filename|
        FileUtils.chdir('./db') do
          File.delete(filename)
        end
      end
    end
  end
end