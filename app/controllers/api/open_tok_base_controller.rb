class Api::OpenTokBaseController < Api::ApiBaseController
  private
  def opentok
    @opentok ||= OpenTok::OpenTok.new ENV['OPEN_TOK_KEY'], ENV['OPEN_TOK_SECRET']
  end
end
