require "test_helper"

class TimeTrackingHelperTest < ActionView::TestCase
  test "format_duration returns 0s for zero seconds" do
    assert_equal "0s", format_duration(0)
    assert_equal "0s", format_duration(nil)
  end

  test "format_duration formats seconds" do
    assert_equal "30s", format_duration(30)
    assert_equal "59s", format_duration(59)
  end

  test "format_duration formats minutes and seconds" do
    assert_equal "1m 0s", format_duration(60)
    assert_equal "1m 30s", format_duration(90)
    assert_equal "45m 0s", format_duration(45 * 60)
  end

  test "format_duration formats hours and minutes without seconds" do
    assert_equal "1h 0m", format_duration(3600)
    assert_equal "1h 30m", format_duration(90 * 60)
    assert_equal "2h 15m", format_duration(135 * 60)
  end

  test "format_duration handles large values" do
    assert_equal "100h 30m", format_duration(100 * 3600 + 30 * 60)
  end

  test "format_duration_long returns humanized text" do
    assert_equal "0 seconds", format_duration_long(0)
    assert_equal "30 seconds", format_duration_long(30)
    assert_equal "1 minute", format_duration_long(60)
    assert_equal "1 minute 30 seconds", format_duration_long(90)
    assert_equal "1 hour", format_duration_long(3600)
    assert_equal "2 hours 15 minutes", format_duration_long(135 * 60)
  end
end
