# responible for calling right parser
class ClassificationService
  include Interactor

  def call
    parse_all_files
  end

  private

  def parse_all_files
    context.parsed_data = []
    %w[sentinels sniffers loopholes].each do |file|
      parse_data(file)
    end
  end

  def parse_data(file)
    notify_and_log_error('Not existing file') unless file_exist?(file)
    adapter = find_parser(file)
    result = adapter.new(file).perform
    context.parsed_data += result
  end

  def file_exist?(file)
    Dir.exist?(Rails.root.join('tmp', file))
  end

  def find_parser(name)
    adapter = "ParserAdapter::#{name.singularize.titleize}".safe_constantize
    return adapter if adapter.present?
    notify_and_log_error('Unknown parser')
  end

  def notify_and_log_error(message)
    Rails.logger.error message
    context.fail!(error: message)
  end
end
