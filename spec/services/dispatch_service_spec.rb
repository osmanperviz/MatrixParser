RSpec.describe DispatchService do
  subject { described_class }
  let(:context) { Interactor::Context.new(parsed_data: [1, 2]) }

  context '#call' do
    context 'on empty parsed data' do
      before do
        allow_any_instance_of(described_class).to receive(:data_present?).and_return(false)
      end
      it 'return failure' do
        result = described_class.call
        expect(result).to be_failure
      end
      it 'has correct error message' do
        result = described_class.call
        expect(result.error).to eq 'No data available'
      end
      it 'log error message' do
        expect(Rails.logger).to receive(:error)
        described_class.call
      end
    end
    context 'response' do
      before do
        allow_any_instance_of(described_class).to receive(:data_present?).and_return(true)
        allow_any_instance_of(described_class).to receive(:context).and_return(context)
        allow_any_instance_of(described_class).to receive(:send_data).and_return(response)
      end
      context 'on failure status' do
        let(:response) { OpenStruct.new(code: 500) }
        it 'is failure' do
          result = described_class.call
          expect(result).to be_failure
          expect(result.error).to eq('something went wrong')
        end
      end
      context 'on success status' do
        let(:response) { OpenStruct.new(code: 201) }
        it 'is success' do
          result = described_class.call
          expect(result).to be_success
        end
      end
    end
  end
end
