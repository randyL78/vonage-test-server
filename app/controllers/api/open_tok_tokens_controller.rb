require 'opentok'
class Api::OpenTokTokensController < Api::OpenTokBaseController
  def create
    session_id = params[:session_id]

    token = opentok.generate_token(session_id, {
      role: :publisher
    })

    render json: {
      token: token
    }
  end
end
