class DispatchService
  include Interactor

  def call
    context.fail!(:error, 'No data available') unless context.parsed_data.any?
    context.parsed_data.each do |data|
      response = send_data_to_matrix_server(data)
      if response.code != 201
        context.fail!(error: 'Something went wrong', data: data)
      end
    end
  end

  private

  def send_data_to_matrix_server(data)
    data['passphrase'] = Rails.application.secrets.matrix_key
    Http.headers('Content-Type' => 'application/json')
      .post(Rails.application.secrets.matrix_endpoint, body: data.to_json)
  end

end
