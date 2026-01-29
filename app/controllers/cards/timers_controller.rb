class Cards::TimersController < ApplicationController
  include CardScoped

  def show
    @time_entry = @card.active_timer_for(Current.user)
  end

  def create
    @time_entry = @card.start_timer_for(Current.user)

    respond_to do |format|
      format.turbo_stream { render_card_replacement }
      format.json { render json: @time_entry, status: :created }
    end
  end

  def destroy
    @card.stop_timer_for(Current.user)

    respond_to do |format|
      format.turbo_stream { render_card_replacement }
      format.json { head :no_content }
    end
  end
end
