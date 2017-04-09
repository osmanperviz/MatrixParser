require 'zip'

# fetch files from server
class FetchAndUnzipService
  include Interactor

  NAMES = %w[sentinels sniffers loopholes].freeze

  def call
    fetch_files
    unzip
  end

  private

  def fetch_files
    NAMES.each do |name|
      open(file_path(name), 'w+') do |file|
        file.binmode
        response = HTTP.get(generate_path(name))

        file.write response
      end
    end
  rescue StandardError => error
    notify_and_log_error(error)
  end

  def unzip
    Zip.on_exists_proc = true
    NAMES.each do |name|
      Zip::File.open(file_path(name)) do |zip_file|
        zip_file.each do |file|
          file.extract("tmp/#{file.name}")
        end
      end
    end
  rescue StandardError => error
    notify_and_log_error(error)
  end

  def generate_path(name)
    "#{end_point}&source=#{name}"
  end

  def end_point
    "#{Rails.application.secrets.matrix_endpoint}?passphrase=#{Rails.application.secrets.matrix_key}"
  end

  def file_path(file)
    file_path ||= "tmp/#{file}.zip"
  end

  def notify_and_log_error(error)
     Rails.logger.info error.message
     fail!(:error, error.message) 
  end
end
