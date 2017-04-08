RSpec.describe FetchAndUnzipService do
  subject { described_class }
    # let(:files) do
    #   Rails.application.config.source_names.map do |entry|
    #     "#{entry}.zip"
    #   end.sort
    # end
  describe '#call' do
    context 'files' do
      it 'has all required files' do
        VCR.use_cassette('first_fetch') do
          response = subject.call
          expect(response).to be_success
        end
      end
    end

  end
end
