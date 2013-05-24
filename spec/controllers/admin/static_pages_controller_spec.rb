require 'spec_helper'

describe Admin::StaticPagesController do

  describe "GET 'edit_home'" do
    it "returns http success" do
      get 'edit_home'
      response.should be_success
    end
  end

  describe "GET 'edit_about'" do
    it "returns http success" do
      get 'edit_about'
      response.should be_success
    end
  end

  describe "GET 'edit_contact'" do
    it "returns http success" do
      get 'edit_contact'
      response.should be_success
    end
  end

end
