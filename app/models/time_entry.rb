class TimeEntry < ApplicationRecord
  belongs_to :account, default: -> { card.account }
  belongs_to :card, touch: true
  belongs_to :user, default: -> { Current.user }

  validates :duration_seconds, numericality: { greater_than_or_equal_to: 0 }

  scope :running, -> { where.not(started_at: nil) }
  scope :completed, -> { where(started_at: nil) }
  scope :chronologically, -> { order(created_at: :asc) }
  scope :reverse_chronologically, -> { order(created_at: :desc) }

  def running?
    started_at.present?
  end

  def stop!
    return unless running?

    elapsed = Time.current - started_at
    update!(duration_seconds: duration_seconds + elapsed.to_i, started_at: nil)
  end

  def duration
    if running?
      duration_seconds + (Time.current - started_at).to_i
    else
      duration_seconds
    end
  end
end
