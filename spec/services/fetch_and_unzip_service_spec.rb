RSpec.describe FetchAndUnzipService do
subject { described_class }
  let(:zip_files) do
    %w(sentinels sniffers loopholes).map do |name|
      "#{name}.zip"
    end.sort
  end
  describe '#call' do
    context '#fetch_files' do
      it 'has success response' do
        VCR.use_cassette('first_fetch') do
          response = subject.call
          expect(response).to be_success
        end
      end
      it 'create zip files in temp folder' do
        expect((Dir.entries(Rails.root.join('tmp')) & zip_files).sort).to eq(zip_files)
      end
    end
    context '#unzip' do
      it 'unzips ziped files' do
        %w(sentinels sniffers loopholes).each do |src|
          expect(Dir.entries(Rails.root.join('tmp', src)).count).to be > 0
        end
      end
    end
  end
end
