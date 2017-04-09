require 'csv'
module ParserAdapter
  class BaseParser
    attr_reader :file_name, :files
    attr_accessor :results

    def initialize(file_name)
      @file_name = file_name
      @files = Dir.glob(Rails.root.join('tmp', file_name, '*')).entries
      @results = []
    end

    private

    def converted_files
      files.map { |file|  { file => convert_to_hash(file) } }
    end

    # def convert_to_hash(file)
    #    CSV.parse(file, headers: true, header_converters: lambda {|f| f.strip}, converters: lambda {|f| f.strip })
    # end

    def convert_to_hash(file)
      CSV.read(
        file,
        headers: true,
        header_converters: lambda {|f| f.strip},
        col_sep: ', '
      ).map(&:to_h)
    end
  end
end
