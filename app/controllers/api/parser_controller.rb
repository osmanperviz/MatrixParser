class Api::ParserController < ApplicationController
  def parse
    result = MatrixParser.call
    if result.success?
      render json: { message: 'everythingting is ok' }, status: :ok
    else
      render json: { message: result.error }, status: 500
    end
  end
end
