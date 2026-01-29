class Cards::TimeEntriesController < ApplicationController
  include CardScoped

  before_action :set_time_entry, only: %i[update destroy]

  def index
    @time_entries = @card.time_entries.reverse_chronologically
  end

  def create
    @time_entry = @card.time_entries.create!(time_entry_params)

    respond_to do |format|
      format.turbo_stream
      format.json { render json: @time_entry, status: :created }
    end
  end

  def update
    @time_entry.update!(time_entry_params)

    respond_to do |format|
      format.turbo_stream
      format.json { render json: @time_entry }
    end
  end

  def destroy
    @time_entry.destroy!

    respond_to do |format|
      format.turbo_stream
      format.json { head :no_content }
    end
  end

  private
    def set_time_entry
      @time_entry = @card.time_entries.find(params[:id])
    end

    def time_entry_params
      params.require(:time_entry).permit(:duration_seconds)
    end
end
