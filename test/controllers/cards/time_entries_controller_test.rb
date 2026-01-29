require "test_helper"

class Cards::TimeEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "index lists time entries for card" do
    get card_time_entries_path(cards(:logo))
    assert_response :success
    assert_select ".time-entry", 2
  end

  test "create adds manual time entry" do
    card = cards(:text)

    assert_difference "TimeEntry.count", 1 do
      post card_time_entries_path(card),
        params: { time_entry: { duration_seconds: 1800 } },
        as: :turbo_stream
    end

    entry = TimeEntry.last
    assert_equal 1800, entry.duration_seconds
    assert_equal users(:kevin), entry.user
  end

  test "create as JSON" do
    card = cards(:text)

    assert_difference "TimeEntry.count", 1 do
      post card_time_entries_path(card),
        params: { time_entry: { duration_seconds: 3600 } },
        as: :json
    end

    assert_response :created
  end

  test "destroy removes time entry" do
    entry = time_entries(:kevin_logo_entry)

    assert_difference "TimeEntry.count", -1 do
      delete card_time_entry_path(cards(:logo), entry), as: :turbo_stream
    end
  end

  test "destroy as JSON" do
    entry = time_entries(:kevin_logo_entry)

    assert_difference "TimeEntry.count", -1 do
      delete card_time_entry_path(cards(:logo), entry), as: :json
    end

    assert_response :no_content
  end
end
