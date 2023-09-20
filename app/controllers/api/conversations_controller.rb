require 'vonage'

class Api::ConversationsController < Api::ApiBaseController
  def index
    session_id = params[:session_id]

    conversations = vonage.conversations.list
    conversations = conversations['_embedded']['conversations']

    response = []

    conversations.each do |conversation|
      next if session_id && session_id != conversation['name']

      response <<
        {
          id: conversation['uuid'],
          session_id: conversation['name']
        }
    end

    render json: response
  end

  def destroy
    session_id = params[:id]

    conversations = vonage.conversations.list
    conversations = conversations['_embedded']['conversations']

    count = 0

    conversations.each do |conversation|
      next unless session_id == conversation['name'] || session_id == 'all'

      vonage.conversations.delete(conversation['uuid'])
      count = count +1
    end

    render json: { count: count }
  end

  private
  def vonage
    @vonage ||= Vonage::Client.new
  end
end