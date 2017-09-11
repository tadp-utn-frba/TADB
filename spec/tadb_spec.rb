describe TADB::DB do

  describe '.table' do

    it 'returns a table' do
      expect(TADB::DB.table('foo')).to be_instance_of TADB::Table
    end

    describe '.clear_all' do

      it 'deletes all tables created in db folder' do
        %w(foo bar baz).each do |name|
          create_table_file(name)
        end

        TADB::DB.clear_all

        expect(Utils.db_files).to be_empty
      end

      def create_table_file(table_name)
        TADB::DB.table('test_' + table_name).insert({})
      end
    end
  end
end