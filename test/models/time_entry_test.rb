require "test_helper"

class TimeEntryTest < ActiveSupport::TestCase
  setup do
    Current.session = sessions(:david)
  end

  test "belongs to account, card, and user" do
    entry = time_entries(:kevin_logo_entry)
    assert_equal accounts("37s"), entry.account
    assert_equal cards(:logo), entry.card
    assert_equal users(:kevin), entry.user
  end

  test "running? returns true when started_at is present" do
    running_entry = time_entries(:kevin_running_timer)
    completed_entry = time_entries(:kevin_logo_entry)

    assert running_entry.running?
    assert_not completed_entry.running?
  end

  test "duration returns stored seconds for completed entries" do
    entry = time_entries(:kevin_logo_entry)
    assert_equal 3600, entry.duration
  end

  test "duration includes elapsed time for running entries" do
    entry = time_entries(:kevin_running_timer)
    assert entry.duration >= 30 * 60
  end

  test "stop! calculates and saves duration" do
    entry = time_entries(:kevin_running_timer)

    assert entry.running?

    travel_to 10.minutes.from_now do
      entry.stop!
    end

    assert_not entry.running?
    assert entry.duration_seconds >= 40 * 60
    assert_nil entry.started_at
  end

  test "stop! does nothing for already stopped entries" do
    entry = time_entries(:kevin_logo_entry)
    original_duration = entry.duration_seconds

    entry.stop!

    assert_equal original_duration, entry.duration_seconds
  end

  test "validates duration_seconds is not negative" do
    entry = TimeEntry.new(
      card: cards(:logo),
      user: users(:david),
      duration_seconds: -100
    )

    assert_not entry.valid?
    assert_includes entry.errors[:duration_seconds], "must be greater than or equal to 0"
  end

  test "scopes: running and completed" do
    assert_includes TimeEntry.running, time_entries(:kevin_running_timer)
    assert_not_includes TimeEntry.completed, time_entries(:kevin_running_timer)

    assert_includes TimeEntry.completed, time_entries(:kevin_logo_entry)
    assert_not_includes TimeEntry.running, time_entries(:kevin_logo_entry)
  end
end
