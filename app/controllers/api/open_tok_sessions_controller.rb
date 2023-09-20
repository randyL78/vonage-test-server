require 'opentok'
class Api::OpenTokSessionsController < Api::OpenTokBaseController
  def create
    session = opentok.create_session media_mode: :routed

    ot_session = OpenTokSession.create({
      session_id: session.session_id,
      api_key: session.api_key,
      location: session.location,
      media_mode: session.media_mode,
      archive_mode: session.archive_mode,
      active: true
    })

    render json: {
      session: ot_session
    }
  end

  def index
    @sessions = OpenTokSession.all.where(active: true)

    render json: @sessions
  end

  def show
    @session = OpenTokSession.find_by_session_id(params[:id])

    render json: @session
  end

  def destroy
    @session = OpenTokSession.find_by_session_id(params[:id])

    @session.update(active: false)

    render json: @session.session_id
  end
end
