require "test_helper"

class Card::TrackableTest < ActiveSupport::TestCase
  setup do
    Current.session = sessions(:david)
  end

  test "total_time_tracked sums all completed entries" do
    card = cards(:logo)
    assert_equal 5400, card.total_time_tracked
  end

  test "total_time_tracked includes running timer duration" do
    card = cards(:layout)
    assert card.total_time_tracked >= 30 * 60
  end

  test "time_tracked_by returns time for specific user" do
    card = cards(:logo)
    assert_equal 3600, card.time_tracked_by(users(:kevin))
    assert_equal 1800, card.time_tracked_by(users(:david))
  end

  test "active_timer_for returns running timer for user" do
    card = cards(:layout)
    timer = card.active_timer_for(users(:kevin))

    assert_not_nil timer
    assert timer.running?
  end

  test "active_timer_for returns nil when no running timer" do
    card = cards(:logo)
    assert_nil card.active_timer_for(users(:david))
  end

  test "has_active_timer_for? returns boolean" do
    assert cards(:layout).has_active_timer_for?(users(:kevin))
    assert_not cards(:logo).has_active_timer_for?(users(:david))
  end

  test "start_timer_for creates new time entry with started_at" do
    card = cards(:logo)
    user = users(:david)

    assert_not card.has_active_timer_for?(user)

    assert_difference "TimeEntry.count", 1 do
      timer = card.start_timer_for(user)
      assert timer.running?
      assert_equal user, timer.user
    end
  end

  test "start_timer_for returns existing timer if already running" do
    card = cards(:layout)
    user = users(:kevin)
    existing_timer = card.active_timer_for(user)

    assert_no_difference "TimeEntry.count" do
      timer = card.start_timer_for(user)
      assert_equal existing_timer, timer
    end
  end

  test "stop_timer_for stops running timer" do
    card = cards(:layout)
    user = users(:kevin)

    assert card.has_active_timer_for?(user)

    card.stop_timer_for(user)

    assert_not card.has_active_timer_for?(user)
  end

  test "stop_timer_for does nothing when no timer running" do
    card = cards(:logo)
    user = users(:david)

    assert_nothing_raised do
      card.stop_timer_for(user)
    end
  end
end
