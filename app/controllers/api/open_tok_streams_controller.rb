class Api::OpenTokStreamsController < Api::OpenTokBaseController
  def index
    session_id = params[:session_id].to_s

    streams = begin
        opentok.streams.all(session_id)
      rescue
        []
      end

    render json: streams
  end

  def show
    session_id = params[:session_id].to_s
    stream_id = params[:id].to_s

    stream = opentok.streams.find(session_id, stream_id)

    render json: stream.to_json
  end

  def destroy
    session_id = params[:session_id].to_s
    stream_id = params[:id].to_s

    stream = opentok.streams.find(session_id, stream_id)

    pp stream

    render json: stream.to_json
  end
end
