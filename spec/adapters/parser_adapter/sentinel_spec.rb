RSpec.describe ParserAdapter::Sentinel do
  subject { described_class }

  context 'perform' do
    let(:correct_format) do
      {
        source: nil,
        start_node: nil,
        end_node: nil,
        start_time: nil,
        end_time: nil
      }
    end

    it 'has good format' do
      results = subject.new('sentinels').perform
      expect(results.first.keys).to eq(correct_format.keys)
    end
    it 'returns an array' do
      results = subject.new('sentinels').perform
      expect(results).to be_kind_of(Array)
    end
    it 'return empty array on non existing sentinels' do
      allow_any_instance_of(described_class).to receive(:converted_files).and_return([nil, nil])
      results = subject.new('sentinels').perform
      expect(results).to be_kind_of Array
    end
  end
end
