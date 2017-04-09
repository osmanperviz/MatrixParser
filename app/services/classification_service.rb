# responible for calling right parser
class ClassificationService
  include Interactor

  # attr_accessor :result

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
    return notify_and_log_error('Not existing file') unless file_exist?(file)
    binding.pry
    adapter = find_parser(file)
    # parser = adapter.new(file)
    # parser.parse
  end

  def file_exist? file
    Dir.exist?(Rails.root.join('tmp', file))
  end

  def find_parser(name)
    adapter = "ParserAdapter::#{name.singularize.titleize}".safe_constantize
    binding.pry
    return adapter if adapter.present?
    context.fail!(error: error.message)
  end

  def notify_and_log_error(message)
    Rails.logger.error message
    context.fail!(error: message)
  end
end
