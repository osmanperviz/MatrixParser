class DispatchService
  include Interactor

  delegate :parsed_data, :fail!,  to: :context

  def call
    notify_and_log_error('No data available') unless data_present?

    create_data
  end

  private

  def create_data
    parsed_data.each do |data|
      response = send_data(data)
      notify_and_log_error if response.code != 201
    end
  end

  def send_data(data)
    data['passphrase'] = Rails.application.secrets.matrix_key
    Http.headers('Content-Type' => 'application/json')
        .post(Rails.application.secrets.matrix_endpoint, body: data.to_json)
  end

  def notify_and_log_error(message)
    Rails.logger.error message
    fail!(error: message)
  end

  def data_present?
    parsed_data.any?
  end
end
