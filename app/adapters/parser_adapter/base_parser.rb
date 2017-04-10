require 'csv'
module ParserAdapter
  class BaseParser
    attr_reader :file_name
    attr_accessor :results, :merged_hash, :sequences, :node_times, :routes, :node_pairs

    def initialize(file_name)
      @file_name = file_name
      @files = Dir.glob(Rails.root.join('tmp', file_name, '*')).entries
      @results = []
      @merged_hash = []
    end

  private

    def converted_files
      @files.map { |file|  file_to_hash(file) }
    end

    def extract_files(extension)
      @files.each do |file_name|
        name = File.basename(file_name, extension)
        instance_variable_set(
          "@#{name}",
          converted_files.detect do |wrapper|
            File.basename(wrapper.keys.first, extension) == name
          end.values.first
        )
      end
    end

    def file_to_hash(file)
      case File.extname(file)
      when '.json'
        { file => json_file_to_hash(file) }
      else
        { file => csv_file_to_hash(file) }
      end
    end

    def csv_file_to_hash(file)
      CSV.read(
        file,
        headers: true,
        header_converters: :symbol,
        col_sep: ', '
      ).map(&:to_h)
    end

    def json_file_to_hash(file)
      JSON.parse(IO.read(file)).with_indifferent_access
    end


    def route_ids(hash)
      hash.map { |row| row[:route_id] }.uniq
    end

    def merge_hashes(base_hash, array, field_1, field_2 = nil)
      field_2 ||= field_1
      to_merge = array.detect do |new_hash|
                   new_hash[field_2] == base_hash[field_1]
                 end
      base_hash.merge(to_merge.except(field_2)) if to_merge.present?
    end

    def collect_uniq_route_ids(hash)
      hash.map { |row| row['route_id'] }.uniq
    end
  end
end
