require 'csv'
module ParserAdapter
  class BaseParser
    attr_reader :file_name
    attr_accessor :results

    def initialize(file_name)
      @file_name = file_name
      @files = Dir.glob(Rails.root.join('tmp', file_name, '*')).entries
      @results = []
    end

  private

    def converted_files
      @files.map { |file|  { file => file_to_hash(file) }  }
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
      CSV.read(
        file,
        headers: true,
        header_converters: :symbol,
        col_sep: ', '
      ).map(&:to_h)
    end

    def route_ids(hash)
      hash.map { |row| row[:route_id] }.uniq
    end

    def merge_hashes(base_hash, array, field)
      to_merge = array.detect do |new_hash|
                   new_hash[field] == base_hash[field]
                 end
      base_hash.merge(to_merge.except(field)) if to_merge.present?
    end

    def collect_uniq_route_ids(hash)
      hash.map { |row| row['route_id'] }.uniq
    end

    def format_object(row)
      {
        source: file_name,
        start_node: row[:start_node],
        end_node: row[:end_node],
        start_time: row[:time],
        end_time: row[:time]
      }
    end

  end
end
