module ParserAdapter
  class BaseParser
    attr_reader :file_name

    def initialize(file_name)
      @file_name = file_name
      @files = Dir.glob(Rails.root.join('tmp', file_name, '*')).entries
    end
  end
end
