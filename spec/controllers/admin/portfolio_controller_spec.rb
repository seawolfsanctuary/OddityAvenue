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
  end

  context "when logged in" do
    before do
      Admin::User.delete_all
      @user = FactoryGirl.create(:admin)
      sign_in @user
    end

    before(:each) do
      PortfolioItem.delete_all
      @item = FactoryGirl.create(:portfolio_item, title: "Item 1", for_sale:  true, hidden: false)
      @item_id = @item.id
    end

    context "GET index" do
      it "should load all the PortfolioItems that are not for sale but are visible" do
        FactoryGirl.create :portfolio_item, title: "Item 2", for_sale:  true, hidden: true
        FactoryGirl.create :portfolio_item, title: "Item 3", for_sale: false, hidden: false
        FactoryGirl.create :portfolio_item, title: "Item 4", for_sale: false, hidden: true
        FactoryGirl.create :portfolio_item, title: "Item 5", for_sale: false, hidden: false

        get 'index'
        response.status.should == 200

        assigns[:items].collect(&:class).should == [ PortfolioItem, PortfolioItem ]
        assigns[:items].collect(&:title).should == [ "Item 3", "Item 5" ]
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
  end
end
