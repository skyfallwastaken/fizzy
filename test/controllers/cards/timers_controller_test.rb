require "test_helper"

class Cards::TimersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "create starts a timer" do
    card = cards(:logo)

    assert_not card.has_active_timer_for?(users(:kevin))

    assert_difference "TimeEntry.count", 1 do
      post card_timer_path(card), as: :turbo_stream
      assert_card_container_rerendered(card)
    end

    assert card.reload.has_active_timer_for?(users(:kevin))
  end

  test "create returns existing timer if already running" do
    card = cards(:layout)

    assert card.has_active_timer_for?(users(:kevin))

    assert_no_difference "TimeEntry.count" do
      post card_timer_path(card), as: :turbo_stream
    end
  end

  test "destroy stops the timer" do
    card = cards(:layout)

    assert card.has_active_timer_for?(users(:kevin))

    delete card_timer_path(card), as: :turbo_stream
    assert_card_container_rerendered(card)

    assert_not card.reload.has_active_timer_for?(users(:kevin))
  end

  test "create as JSON" do
    card = cards(:logo)

    post card_timer_path(card), as: :json

    assert_response :created
    assert card.reload.has_active_timer_for?(users(:kevin))
  end

  test "destroy as JSON" do
    card = cards(:layout)

    delete card_timer_path(card), as: :json

    assert_response :no_content
    assert_not card.reload.has_active_timer_for?(users(:kevin))
  end
end
