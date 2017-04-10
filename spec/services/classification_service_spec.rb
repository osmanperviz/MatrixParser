RSpec.describe ClassificationService do
  subject { described_class }
  describe '#call' do
    context 'parse correct files' do
      it 'will call #parse_data exact 3 times' do
        expect_any_instance_of(described_class).to receive(:parse_data).exactly(3).times
        subject.call
      end

      %w[sentinels sniffers loopholes].each do |file|
        it "recive #{file} as arrgument" do
          allow_any_instance_of(described_class).to receive(:parse_data)
          expect_any_instance_of(described_class).to receive(:parse_data).with(file).at_least(:once)
          subject.call
        end
      end
      context 'not existing file' do
        before do
          expect_any_instance_of(described_class).to receive(:file_exist?).and_return(false)
        end

        it 'return correct error' do
          result = subject.call
          expect(result).to be_failure
          expect(result.error).to eq 'Not existing file'
        end

        it 'logs error' do
          expect(Rails.logger).to receive(:error)
          result = subject.call
        end
      end
    end
    context '#find_parser' do
      context 'existing parser' do
        after do
          subject.call
        end
        %w[Sentinel Sniffer Loophole].each do |parser|
          it "call #{parser} parser" do
            expect_any_instance_of("ParserAdapter::#{parser}".safe_constantize).to receive(:perform).and_return([])
          end
        end
      end
    end
  end
end
