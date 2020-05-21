require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:tester)

    sign_in (@user)
  end

  test "should get index" do
    get admin_users_url(locale: 'es')
    assert_response :success
  end

  test "should get new" do
    get new_admin_user_url(locale: 'es')
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post admin_users_url(locale: 'es'),
        params: {
          user: {
            name: "Stanley",
            complete_name: 'Ariel',
            email: "sta@sta.com",
            role_id: roles(:admin).id,
            password: '123456',
            city: "Mendoza"
          }
      }
    end

    assert_redirected_to admin_users_url()
  end

  test "should show user" do
    get admin_user_url(@user, locale: 'es')
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_user_url(@user, locale: 'es')
    assert_response :success
  end

  test "should update user" do
    patch admin_user_url(@user, locale: 'es'),
      params: {
        user: {
          name: "John"
        }
    }

    assert_redirected_to admin_user_url(@user)
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete admin_user_url(@user, locale: 'es')
    end

    assert_redirected_to admin_users_url
  end
end
