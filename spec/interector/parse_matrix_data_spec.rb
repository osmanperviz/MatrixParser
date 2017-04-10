RSpec.describe MatrixParser do
  subject { described_class }

  context 'server respond with 201' do
    it 'successfully parse and create matrix stuff' do
      VCR.use_cassette('finished_task_server_response') do
        response = subject.call
        expect(response).to be_success
      end
    end
  end
end
