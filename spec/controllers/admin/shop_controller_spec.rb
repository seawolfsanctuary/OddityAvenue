require 'spec_helper'

describe Admin::ShopController do

  context "when not logged in" do
    before do
      ShopItem.delete_all
      @item = FactoryGirl.create(:shop_item)
    end

    context "GET 'index'" do
      it "should redirect to the login page" do
        get 'index'
        response.should redirect_to new_user_session_path
      end
    end

    context "GET 'new'" do
      it "should redirect to the login page" do
        get 'new'
        response.should redirect_to new_user_session_path
      end
    end

    context "PUT 'create'" do
      it "should redirect to the login page" do
        put 'create', shop_item: @item
        response.should redirect_to new_user_session_path
      end
    end

    context "GET 'edit'" do
      it "should redirect to the login page" do
        get 'edit', id: @item.id
        response.should redirect_to new_user_session_path
      end
    end

    context "POST 'update'" do
      it "should redirect to the login page" do
        post 'update', id: @item.id
        response.should redirect_to new_user_session_path
        ShopItem.find(@item.id).should == @item
      end
    end

    context "POST 'delete'" do
      it "should redirect to the login page" do
        delete 'destroy', id: @item.id
        response.should redirect_to new_user_session_path
        ShopItem.find(@item.id).should == @item
      end
    end
  end

  context "when logged in" do
    before do
      Admin::User.delete_all
      @user = FactoryGirl.create(:admin)
      sign_in @user
    end

    before(:each) do
      ShopItem.delete_all
      @item = FactoryGirl.create(:shop_item)
      @item_id = @item.id
    end

    context "GET index" do
      it "should load all the ShopItems that are not for sale but are visible" do
        4.times do
          FactoryGirl.create :shop_item
        end

        get 'index'
        response.status.should == 200

        assigns[:items].collect(&:class).should == [
          ShopItem, ShopItem,
          ShopItem, ShopItem,
          ShopItem
        ]
      end
    end

    context "PUT 'create'" do
      it "should create the given ShopItem" do
        put 'create', shop_item: {
          title: @item.title,
          description: @item.description,
          image_filename_1: @item.image_filename_1,
          image_filename_2: @item.image_filename_2,
          image_filename_3: @item.image_filename_3,
          thumbnail_filename: @item.thumbnail_filename
        }
        response.status.should == 302
        ShopItem.all.should include(@item)
      end

      it "should protect against mass-assignment" do
        lambda {
          put 'create', shop_item: {
            title: @item.title,
            description: @item.description,
            hacker_attempt: "foiled!"
          }
        }.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end

    context "GET edit" do
      it "should load the given ShopItem" do
        get 'edit', id: @item.id
        assigns[:item].should == @item
      end
    end

    context "POST update" do
      it "should update the given ShopItem with the given values" do
        post 'update', {
          id: @item.id,
          shop_item: {
            title: "My New Title",
            description: "This has been modified."
          }
        }

        @item.reload
        @item.title.should == "My New Title"
        @item.description.should == "This has been modified."
      end
    end

    context "POST delete" do
      it "should delete the given ShopItem" do
        lambda { ShopItem.find(@item_id) }.should_not raise_error(ActiveRecord::RecordNotFound)
        delete 'destroy', id: @item_id
        lambda { ShopItem.find(@item_id) }.should     raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end