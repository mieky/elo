# -*- coding: utf-8 -*-
class HistoricalGame
  include ActiveModel::Serialization

  def initialize(player, audit)
    self.player = player
    self.audit = audit
    self.changes = audit.audited_changes
  end

  GAME_ATTRIBUTES = [:winner_names, :loser_names, :margin]
  PLAYER_ATTRIBUTES = ["rank", "doubles_rank", "last_expected_margin"]
  def as_json(options = {})
    attributes = {
      :date => date,
      :change => change,
    }
    (GAME_ATTRIBUTES + PLAYER_ATTRIBUTES).each do |attr|
      attributes[attr.to_s.gsub(/last_/,'')] = self.send(attr) if self.send(attr)
    end
    attributes
  end

  def description
    "#{winner_names} beat #{loser_names} by #{margin}/#{last_expected_margin} (Δ#{change}) on #{date.to_formatted_s('%d-%m')}"
  end

  def date
    return game.created_at if game
    audit.created_at
  end

  GAME_ATTRIBUTES.each do |attr|
    define_method(attr) do
      game.send(attr) if game
    end
  end

  PLAYER_ATTRIBUTES.each do |attr|
    define_method(attr) do
      new_value(attr)
    end
  end

  def rank
    return if game and ! game.is_singles_game?
    new_value("rank") || player.rank
  end

  def doubles_rank
    return if game and game.is_singles_game?
    new_value("doubles_rank") || player.doubles_rank
  end

  def change
    attr = rank ? "rank" : "doubles_rank"
    return 0 unless new_value(attr)
    new_value(attr) - old_value(attr)
  end

  private

  def new_value(attr)
    changes[attr][-1] if changes[attr]
  end

  def old_value(attr)
    changes[attr][0] if changes[attr]
  end

  def game
    return @game if @game
    return unless game_id = new_value("last_game_id")
    Rails.logger.debug("loading game #{game_id}")
    @game = Game.find_by_id(game_id)
  end

  attr_accessor :player, :audit, :changes
end
