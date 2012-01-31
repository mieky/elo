class PlayersController < InheritedResources::Base
  respond_to :html, :json

  helper_method :recent_games, :scores_over_time, :other_players

  def create
    super do |format|
      format.html { redirect_to players_path }
    end
  end

  def update
    super do |format|
      format.html { redirect_to players_path }
    end
  end

  private

  def scores_over_time
    @player.score_history
  end

  def collection
    @players ||= Player.by_rank
  end

  def recent_games
    (Game.all + DoublesGame.all).sort_by(&:created_at).reverse
  end

  def other_players
    Player.all(:order => "rank DESC") - [@player]
  end
end
