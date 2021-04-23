describe 'Edge Cases' do
  let(:table_name) { 'test' }
  let(:table) { TADB::Table.new(table_name) }
  let(:inserted_value) { {subject: 'tadp'} }
  let(:inserted_id) { table.insert(inserted_value) }

  # let expressions for reading the table without using the table instance_methods
  let(:raw_content) { File.open(table.send(:db_path)).readlines }
  let(:parsed_content) { raw_content.map { |l| JSON.parse(l, symbolize_names: true) } }

  after do
    TADB::DB.clear_all
  end

  before do
    inserted_id
  end

  context 'whnen we read the content file right after the insert' do
    let(:new_value) { {subject: 'iasc'} }
    
    it 'should not be empty file' do
      expect(File.read(table.send(:db_path))).not_to be_empty    
    end

    it 'should reflect the same value' do
      expect(parsed_content).to include(include(inserted_value))
    end

    it 'should have a new value reflected' do
      table.insert( subject: 'iasc') 
      expect(parsed_content).to include(include(new_value))
    end
  end

  context 'when we want to read an deleted value' do
    subject(:delete) { table.delete(inserted_id) }

    it 'should not include now the inserted value' do
      subject
      expect(parsed_content).not_to include(include(inserted_value))
    end

    it 'should be an empty table' do
      subject
      expect(File.read(table.send(:db_path))).to be_empty  
    end
  end
end