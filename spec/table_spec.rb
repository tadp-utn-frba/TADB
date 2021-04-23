describe TADB::Table do
  let(:table_name) { 'test' }
  let(:table) { TADB::Table.new(table_name) }

  after do
    TADB::DB.clear_all
  end

  describe '#insert' do
    it 'adds one row' do
      table.insert({subject: 'tadp'})
      expect(table.entries).to have_exactly(1).row
      expect(table.entries.first).to include(subject: 'tadp')
    end
  end

  describe '#entries' do
    context 'when the table is empty' do
      let(:table_name) { 'cars' }

      it {expect(table.entries).to be_empty}
    end

    context 'when the table has rows' do
      let(:table) do
        TADB::Table.new(table_name).tap do |table|
          table.insert(model: 'Chevrolet Camaro')
          table.insert(model: 'Toyota Corolla')
        end
      end

      context 'returns a list with each row' do
        it { expect(table.entries).to have_exactly(2).cars }
      end
    end
  end


  describe '#clear' do
    it 'removes all rows' do
      2.times {table.insert({})}
      table.clear
      expect(table.entries).to be_empty
    end
  end

  describe '#delete' do
    it 'removes one row' do
      last_id = table.insert({})
      table.delete(last_id)
      expect(table.entries).to be_empty
    end

    context 'when the id does not exists' do
      it 'does not change the table' do
        table.insert({})
        table.delete('foobar')
        expect(table.entries).to have_exactly(1).row
      end
    end
  end
end