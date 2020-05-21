require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  def login user: users(:tester)
    ¦ expected_text = I18n.t 'flash.sessions.create.logged_in'

    ¦ visit login_url

    ¦ fill_in :email, with: user.email
    ¦ fill_in :password, with: '123456'

    ¦ click_on I18n.t('sessions.new.log_in')
    ¦ assert_selector '.alert.alert-info', text: expected_text
  end
end
