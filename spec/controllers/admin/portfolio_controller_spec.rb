require 'spec_helper'

describe Admin::PortfolioController do

  context "when not logged in" do
    before do
      PortfolioItem.delete_all
      @item = FactoryGirl.create(:portfolio_item)
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
        put 'create', portfolio_item: @item
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
        PortfolioItem.find(@item.id).should == @item
      end
    end

    context "POST 'delete'" do
      it "should redirect to the login page" do
        delete 'destroy', id: @item.id
        response.should redirect_to new_user_session_path
        PortfolioItem.find(@item.id).should == @item
      end
    end

    context "POST 'move_to_shop'" do
      it "should redirect to the login page" do
        post 'move_to_shop', id: @item.id
        response.should redirect_to new_user_session_path
        PortfolioItem.find(@item.id).should == @item
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
      PortfolioItem.delete_all
      @item = FactoryGirl.create(:portfolio_item)
      @item_id = @item.id
    end

    context "GET index" do
      it "should load all the PortfolioItems" do
        4.times do
          FactoryGirl.create :portfolio_item
        end

        get 'index'
        response.status.should == 200

        assigns[:items].collect(&:class).should == [
          PortfolioItem, PortfolioItem,
          PortfolioItem, PortfolioItem,
          PortfolioItem
        ]
      end
    end

    context "PUT 'create'" do
      it "should create the given PortfolioItem" do
        put 'create', portfolio_item: {
          title: @item.title,
          description: @item.description,
          image_filename_1: @item.image_filename_1,
          image_filename_2: @item.image_filename_2,
          image_filename_3: @item.image_filename_3,
          thumbnail_filename: @item.thumbnail_filename
        }
        response.status.should == 302
        PortfolioItem.all.should include(@item)
      end

      it "should protect against mass-assignment" do
        lambda {
          put 'create', portfolio_item: {
            title: @item.title,
            description: @item.description,
            hacker_attempt: "foiled!"
          }
        }.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end

    context "GET edit" do
      it "should load the given PortfolioItem" do
        get 'edit', id: @item.id
        assigns[:item].should == @item
      end
    end

    context "POST update" do
      it "should update the given PortfolioItem with the given values" do
        post 'update', {
          id: @item.id,
          portfolio_item: {
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
      it "should delete the given PortfolioItem" do
        lambda { PortfolioItem.find(@item_id) }.should_not raise_error(ActiveRecord::RecordNotFound)
        delete 'destroy', id: @item_id
        lambda { PortfolioItem.find(@item_id) }.should     raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "POST move_to_shop" do
      before(:each) do
        ShopItem.delete_all
        PortfolioItem.delete_all
      end

      it "should not call PortfolioItem#move when the PortfolioItem cannot be found" do
        i = FactoryGirl.create(:portfolio_item)
        PortfolioItem.any_instance.should_not_receive(:move)
        post :move_to_shop, { "id" => -1 }
      end

      it "should show an error message when unsuccessful because the PortfolioItem cannot be found" do
        i = FactoryGirl.create(:portfolio_item)
        post :move_to_shop, { "id" => -1 }
        flash[:error].should == "Unable to find that portfolio item."
        flash[:info].should be_blank
      end

      it "should show an error message when unsuccessful because the ShopItem cannot be created" do
        i = FactoryGirl.create(:portfolio_item)
        PortfolioItem.any_instance.should_receive(:move).once.and_return(-1)
        post :move_to_shop, { "id" => i[:id] }
        flash[:error].should == "Unable to create shop item. Please create and delete manually."
        flash[:info].should be_blank
      end

      it "should show an error message when unsuccessful because the PortfolioItem cannot be destroyed" do
        i = FactoryGirl.create(:portfolio_item)
        PortfolioItem.any_instance.should_receive(:move).once.and_return(0)
        post :move_to_shop, { "id" => i[:id] }
        flash[:error].should == "Item copied, but unable to delete portfolio item. Please delete manually."
        flash[:info].should be_blank
      end

      it "should show an info message when successful" do
        i = FactoryGirl.create(:portfolio_item)
        PortfolioItem.any_instance.should_receive(:move).once.and_return(1)
        post :move_to_shop, { "id" => i[:id] }
        flash[:error].should be_blank
        flash[:info].should == "Item moved successfully."
      end
    end
  end
end
