class Stats::DecksController < ApplicationController
  respond_to :json, :html

  include Stats

  def index
    @stats = {
      overall: {
      },
      by_deck: {
        vs: {},
        as: {}
      }
    }

    if params[:as_deck].present?
      @as_deck = current_user.decks.find_by_id(params[:as_deck])
    end
    if params[:vs_deck].present?
      @vs_deck = current_user.decks.find_by_id(params[:vs_deck])
    end

    @stats[:by_deck][:as] = group_results_by(user_results, @as_deck || current_user.decks, :deck_id, :opponent_deck_id, @vs_deck.try(:id))
    @stats[:by_deck][:vs] = group_results_by(user_results, @vs_deck || current_user.decks, :opponent_deck_id, :deck_id, @as_deck.try(:id))

    @stats[:overall][:wins] = user_results.wins.count
    @stats[:overall][:losses] = user_results.losses.count

    respond_to do |format|
      format.html
      format.json do
        render json: {stats: @stats}
      end
    end
  end

end
