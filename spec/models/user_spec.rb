require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :username => "user",
      :email => "user@example.com",
      :password => "changeme",
      :password_confirmation => "changeme"
    }
  end

  it "should create a new instance given a valid attribute" do
    User.create!(@attr)
  end

  # Username validation
  it "should require a username" do
    no_username_user = User.new(@attr.merge(:username => ""))
    no_username_user.should_not be_valid
  end

  it "should accept good usernames" do
    names = %w[user1 usr 1234a]
    names.each do |name|
      valid_username_user = User.new(@attr.merge(:username => name))
      valid_username_user.should be_valid
    end
  end

  it "should require unique usernames" do
    user1 = User.create!(@attr.merge(:username => "lowercase"))
    user2 = User.new(@attr.merge(:username => "Lowercase"))

    user2.should_not be_valid
  end

  it "should lowercase all usernames" do
    user1 = User.create!(@attr.merge(:username => "UPPERCASE"))
    user1.username.should_not == "UPPERCASE"
    user1.username.should == "uppercase"
  end

  it "should reject invalid usernames" do
    whitespace_name_user = User.new(@attr.merge(:username => "bob smith"))
    whitespace_name_user.should_not be_valid

    names = %w[admin 1233 aa]
    names.each do |name|
      invalid_username_user = User.new(@attr.merge(:username => name))
      invalid_username_user.should_not be_valid
    end
  end

  # Email validation
  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "passwords" do

    before(:each) do
      @user = User.new(@attr)
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end

  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end

  end

  describe "key generation" do
    it "should generate a key on creation" do
      @user = User.create!(@attr)
      @user.api_key.should_not be_blank
    end
  end
end