require 'test_helper'

class BotTest < ActiveSupport::TestCase

  setup do
    @bots = bots :department_one
  end

  test 'create' do
    assert_difference 'Bot.count' do
      @bots = Bot.create(
        code: 'Code02'
      )
    end
  end
end
