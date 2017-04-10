module ParserAdapter
  class Sniffer < BaseParser
    def perform
      extract_files('.csv')
      return [] unless instances_exsists?
      addapt_note_items
      addapt_route_times
      addapt_format
    end

    private

    def instances_exsists?
      sequences.present? &&
        node_times.present? &&
        routes.present?
    end

    def addapt_note_items
      sequences.each do |sequence|
        merged_node_time = merge_hashes(sequence, node_times, :node_time_id)
        merged_hash << sequence.merge(merged_node_time) if merged_node_time.present?
      end
    end

    def addapt_route_times
      merged_hash.each do |hash|
        route = merge_hashes(hash, routes, :route_id)
        hash.merge!(route) if route.present?
      end
    end

    def addapt_format
      collect_uniq_route_ids(merged_hash).each do |id|
        collect_routes_with_same_id(id).each do |row|
          results << format_object(row)
        end
      end
      results
    end

    def collect_routes_with_same_id(id)
      merged_hash
        .select { |row| row[:route_id] == id }
        .sort_by { |row| row[:node_time_id] }
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
