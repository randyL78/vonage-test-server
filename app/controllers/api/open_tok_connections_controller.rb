# frozen_string_literal: true

class Api::OpenTokConnectionsController < Api::OpenTokBaseController
  def create
    from_phone = ENV['NEXMO_PHONE']
    username = ENV['VONAGE_API_KEY']
    password = ENV['VONAGE_API_SECRET']

    session_id = params[:payload][:session_id].to_s

    token_data = "{\"sip\":true, \"role\":\"client\", \"name\":\"'#{from_phone}'\"}"
    token = opentok.generate_token(session_id, data: token_data)

    sip_uri = "sip:#{from_phone}@sip.nexmo.com"

    options = {
      from: from_phone,
      auth: {
        username: username,
        password: password
      },
      secure: true
    }

    connection = opentok.sip.dial(session_id, token, sip_uri, options)

    OpenTokConnection.create(session_id: session_id, connection_id: connection['connectionId'])

    head :ok
  end
  def index
    session_id = params[:session_id]

    @connections = OpenTokConnection.where(session_id: session_id, active: true).order(created_at: :desc)

    render json: @connections
  end

  def destroy
    connection_id = params[:id].to_s
    session_id = params[:session_id].to_s

    conn = OpenTokConnection.where(connection_id: connection_id, session_id:session_id).first

    return render json: :ok unless conn

    conn.update(active: false)

    opentok.connections.forceDisconnect(session_id, connection_id)

    render json: params[:id]
  end
end
