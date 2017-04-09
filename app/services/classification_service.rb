# responible for calling right parser
class ClassificationService
  include Interactor

  def call
    parse_all_files
  end

  private

  def parse_all_files
    %w(sentinels sniffers loopholes).each do |file|
      parse_data(file)
    end
  end

  def parse_data(file)
    return unless file_exist?
    adapter = find_parser(file)
    parser = adapter.new(file)
    parser.parse
  end

  def file_exist? file
    Dir.exist?(Rails.root.join('tmp', file))
  end

  def find_parser(name)
    adapter = "ParserAdapter::#{file}".safe_constantize
    return adapter if adapter.present?
    fail!(:error, error.message)
  end

end
