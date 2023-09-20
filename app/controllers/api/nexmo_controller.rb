require 'vonage'
class Api::NexmoController < Api::ApiBaseController
  def answer
    session_id = params['SipHeader_X-OpenTok-SessionId']

    ncco = [{
      action: 'conversation',
      name: session_id
    }]

    render json: ncco
  end

  def events
    status = params[:status]
    to_phone = params[:to]
    conversation_id = params[:conversation_uuid]

    return head :ok unless status == 'completed'

    return head :ok if to_phone.blank? || to_phone == ENV['NEXMO_PHONE']

    return head :ok unless conversation_id

    vonage.conversations.delete(conversation_id)

    head :ok
  end

  def fallback
    head :ok
  end


  private

  def vonage
    @vonage ||= Vonage::Client.new
  end
end