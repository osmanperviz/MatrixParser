module ParserAdapter
  class Sentinel < BaseParser

    def perform
      return [] unless sentinels_exist?

      operate_over_sentinels
    end

    private

    def operate_over_sentinels
      converted_files.each do |wrapper|
        wrapper.values.each do |row|
          collect_uniq_route_ids(row).each do |id|
            sequences = collect_routes_with_same_id(row, id)
            create_result(ssequences)
          end
        end
      end
      results
    end

    def create_results(sequences)
      0.upto(sequences.count).each do |index|
        next unless last_row?(sequences, index)
        results << format_object(sequences, index)
      end
    end

    def collect_routes_with_same_id(hash, id)
      hash
        .select { |row| row[:route_id] == id }
        .sort_by { |row| row[:index] }
    end

    def sentinels_exist?
      converted_files.any?
    end

    def format_object(sequences, index)
      {
        source: file_name,
        start_node: sequences[index][:node],
        end_node: sequences[index + 1][:node],
        start_time: format_time(sequences[index][:time]),
        end_time: format_time(sequences[index + 1][:time])
      }
    end

    def last_row?(sequences, index)
      sequences[index + 1].present?
    end

    def format_time(time)
      DateTime.strptime(time, '%Y-%m-%dT%H:%M:%S%z')
              .utc
              .strftime('%FT%T')
    end
  end
end
