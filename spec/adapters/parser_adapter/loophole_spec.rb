RSpec.describe ParserAdapter::Loophole do
  subject { described_class }
  context '' do
    it '' do
      VCR.use_cassette('first_fetch') do
        a = subject.new('loopholes').perform
        binding.pry
      end
    end
  end
end
