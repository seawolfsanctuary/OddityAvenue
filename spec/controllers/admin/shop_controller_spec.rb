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
      end
    end

    context "POST 'delete'" do
      it "should redirect to the login page" do
        delete 'destroy', id: @item.id
        response.should redirect_to new_user_session_path
      end
    end

    context "GET 'move_to_portfolio'" do
      it "should redirect to the login page" do
        get 'move_to_portfolio', id: @item.id
        response.should redirect_to new_user_session_path
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

    context "POST update_delivery_opts" do
      it "should create delivery options when none exist" do
        StaticContent.delete_all
        post :update_delivery_opts, { "delivery_opts" => "New Content" }
        flash[:info].should == "Successfully created delivery content."
        c = StaticContent.last
        c.page.should == "shop"
        c.part.should == "delivery_opts"
        c.body.should == "New Content"
        response.should redirect_to(admin_shop_index_path)
      end

      it "should update delivery options when some exist" do
        StaticContent.delete_all
        post :update_delivery_opts, { "delivery_opts" => "New Content" }
        post :update_delivery_opts, { "delivery_opts" => "Newer Content" }
        flash[:info].should == "Successfully updated delivery content."
        c = StaticContent.last
        c.page.should == "shop"
        c.part.should == "delivery_opts"
        c.body.should == "Newer Content"
        response.should redirect_to(admin_shop_index_path)
      end
    end

    context "GET move_to_portfolio" do
      before(:each) do
        PortfolioItem.delete_all
        ShopItem.delete_all
      end

      it "should not call ShopItem#move when the ShopItem cannot be found" do
        i = FactoryGirl.create(:shop_item)
        ShopItem.any_instance.should_not_receive(:move)
        get :move_to_portfolio, { "id" => -1 }
      end

      it "should show an error message when unsuccessful because the ShopItem cannot be found" do
        i = FactoryGirl.create(:shop_item)
        get :move_to_portfolio, { "id" => -1 }
        flash[:error].should == "Unable to find that shop item."
        flash[:info].should be_blank
      end

      it "should show an error message when unsuccessful because the PortfolioItem cannot be created" do
        i = FactoryGirl.create(:shop_item)
        ShopItem.any_instance.should_receive(:move).once.and_return(-1)
        get :move_to_portfolio, { "id" => i[:id] }
        flash[:error].should == "Unable to create portfolio item. Please create and delete manually."
        flash[:info].should be_blank
      end

      it "should show an error message when unsuccessful because the ShopItem cannot be destroyed" do
        i = FactoryGirl.create(:shop_item)
        ShopItem.any_instance.should_receive(:move).once.and_return(0)
        get :move_to_portfolio, { "id" => i[:id] }
        flash[:error].should == "Item copied, but unable to delete shop item. Please delete manually."
        flash[:info].should be_blank
      end

      it "should show an info message when successful" do
        i = FactoryGirl.create(:shop_item)
        ShopItem.any_instance.should_receive(:move).once.and_return(1)
        get :move_to_portfolio, { "id" => i[:id] }
        flash[:error].should be_blank
        flash[:info].should == "Item moved successfully."
      end
    end
  end
end
