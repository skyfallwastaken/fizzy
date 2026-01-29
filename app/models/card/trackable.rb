module Card::Trackable
  extend ActiveSupport::Concern

  included do
    has_many :time_entries, dependent: :destroy
  end

  def total_time_tracked
    time_entries.sum(:duration_seconds) + running_timers_duration
  end

  def time_tracked_by(user)
    time_entries.where(user: user).sum(:duration_seconds) + running_timer_duration_for(user)
  end

  def active_timer_for(user)
    time_entries.running.find_by(user: user)
  end

  def has_active_timer_for?(user)
    active_timer_for(user).present?
  end

  def start_timer_for(user)
    return active_timer_for(user) if has_active_timer_for?(user)

    time_entries.create!(user: user, started_at: Time.current)
  end

  def stop_timer_for(user)
    active_timer_for(user)&.stop!
  end

  private
    def running_timers_duration
      time_entries.running.sum do |entry|
        (Time.current - entry.started_at).to_i
      end
    end

    def running_timer_duration_for(user)
      timer = active_timer_for(user)
      timer ? (Time.current - timer.started_at).to_i : 0
    end
end
