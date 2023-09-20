require 'vonage'
class Api::PhoneCallsController < Api::OpenTokBaseController
  def create
    method = ENV['CALL_METHOD']
    session_id = params[:session_id].to_s

    return render json: nexmo_create_call(session_id) unless method == 'opentok'

    render json: opentok_create_call(session_id)
  end

  def destroy
    session_id = params[:id].to_s

    connections = OpenTokConnection.where(session_id: session_id)

    connections.each do |connection|
      connection.update(active: false)

      opentok.connections.forceDisconnect(session_id, connection.connection_id)
    end

    render json: :ok
  end


  private
  def opentok_create_call(session_id)
    from_phone = ENV['NEXMO_PHONE']
    username = ENV['VONAGE_API_KEY']
    password = ENV['VONAGE_API_SECRET']
    to_phone = ENV['TO_PHONE']

    token_data = "{\"sip\":true, \"role\":\"client\", \"name\":\"'#{to_phone}'\"}"
    token = opentok.generate_token(session_id, data: token_data)

    sip_uri = "sip:#{to_phone}@sip.nexmo.com;transport=tls"

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
  end

  def nexmo_create_call(session_id)
    from_phone = ENV['NEXMO_PHONE']
    base_api = ENV['BASE_API_URL']
    to_phone = ENV['TO_PHONE']

    ncco = [
      {
        action: 'notify',
        payload: {
          session_id: session_id
        },
        eventUrl: [
          "#{base_api}/api/open_tok_connections"
        ],
        eventMethod: 'POST'
      },
      {
        action: 'conversation',
        name: session_id
      }
    ]

    vonage.voice.create({
      ncco: ncco,
      to: [{
        type: 'phone',
        number: to_phone
      }],
      from: {
       type: 'phone',
       number: from_phone
      },
      machine_detection: 'hangup',
      ringing_timer: 25
   })
  end

  def vonage
    @vonage ||= Vonage::Client.new
  end
end