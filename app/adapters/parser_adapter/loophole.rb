module ParserAdapter
  class Loophole < BaseParser

    def perform
      extract_files('.json')
      return [] unless instances_exsist?
      addapt_routes
      create_format
    end

    private

    def instances_exsist?
      routes.present? && node_pairs.present?
    end

    def addapt_routes
      routes['routes'].each do |route|
        node_pair = merge_hashes(route, node_pairs['node_pairs'], :node_pair_id, :id)
        merged_hash << route.merge(node_pair) if node_pair.present?
      end
    end

    def create_format
      merged_hash.each do |row|
        results << format_object(row)
      end
      results
    end

    def format_object(row)
      {
        source: file_name,
        start_node: row[:start_node],
        end_node: row[:end_node],
        start_time: format_time(row[:start_time]),
        end_time: format_time(row[:end_time])
      }
    end

     def format_time(time)
       time.delete('Z')
     end
  end
end
