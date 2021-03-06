require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup 
    @user = User.new( name: "kyaoru", email: "kyaoru@example.com",
                      password: "minecraft", password_confirmation: "minecraft")
  end
  
  test "should be valid" do
    assert @user.valid?
  end

  test "name should be presence" do
    @user.name = " "
    assert_not @user.valid?
  end

  test "email should be presence" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com example.org, google@gm_ail.com, yahoo@gmai+l.org]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique regardless of up/downcase" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as downcase" do
    mixed_email = "HelLoWorLD@EXampLe.COm"
    @user.email = mixed_email
    @user.save
    assert_equal mixed_email.downcase, @user.reload.email
  end

  test "password should be presence" do
    @user.password = @user.password_confirmation = " " * 5
    assert_not @user.valid?
  end

  test "password should be at least 5 characters" do
    @user.password = @user.password_confirmation = "a" * 4
    assert_not @user.valid?
  end

  test "should authenticated return false when for a user with nil digest" do
    assert_not @user.authenticated?("anything")
  end

  test "associated posts should be destroyed" do
    @user.save
    @user.posts.create!(title: "title", body: "body", category: "japanese")
    assert_difference "Post.count", -1 do
      @user.destroy
    end
  end
end