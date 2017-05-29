require 'spec_helper'

describe Admin::ShopController, type: :controller do
  context "when not logged in" do
    before do
      ShopItem.delete_all
      @item = FactoryGirl.create(:shop_item)
    end

    context "GET 'index'" do
      it "should redirect to the login page" do
        get 'index'
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "GET 'new'" do
      it "should redirect to the login page" do
        get 'new'
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "PUT 'create'" do
      it "should redirect to the login page" do
        put 'create', params: { shop_item: @item }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "GET 'edit'" do
      it "should redirect to the login page" do
        get 'edit', params: { id: @item.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "POST 'update'" do
      it "should redirect to the login page" do
        post 'update', params: { id: @item.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "POST 'delete'" do
      it "should redirect to the login page" do
        delete 'destroy', params: { id: @item.id }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "GET 'move_to_portfolio'" do
      it "should redirect to the login page" do
        get 'move_to_portfolio', params: { id: @item.id }
        expect(response).to redirect_to new_user_session_path
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
        expect(response.status).to eq(200)

        expect(assigns[:items].collect(&:class)).to eq([
          ShopItem, ShopItem,
          ShopItem, ShopItem,
          ShopItem
        ])
      end
    end

    context "PUT 'create'" do
      it "should create the given ShopItem" do
        put 'create', params: { shop_item: {
          title: @item.title,
          description: @item.description,
          image_filename_1: @item.image_filename_1,
          image_filename_2: @item.image_filename_2,
          image_filename_3: @item.image_filename_3,
          thumbnail_filename: @item.thumbnail_filename
        } }
        expect(response.status).to eq(302)
        expect(ShopItem.all).to include(@item)
      end
    end

    context "GET edit" do
      it "should load the given ShopItem" do
        get 'edit', params: { id: @item.id }
        expect(assigns[:item]).to eq(@item)
      end
    end

    context "POST update" do
      it "should update the given ShopItem with the given values" do
        post 'update', params: {
          id: @item.id,
          shop_item: {
            title: "My New Title",
            description: "This has been modified."
          }
        }

        @item.reload
        expect(@item.title).to eq("My New Title")
        expect(@item.description).to eq("This has been modified.")
      end
    end

    context "POST delete" do
      it "should delete the given ShopItem" do
        expect { ShopItem.find(@item_id) }.not_to raise_error # ActiveRecord::RecordNotFound
        delete 'destroy', params: { id: @item_id }
        expect { ShopItem.find(@item_id) }.to     raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "GET move_to_portfolio" do
      before(:each) do
        PortfolioItem.delete_all
        ShopItem.delete_all
      end

      it "should not call ShopItem#move when the ShopItem cannot be found" do
        i = FactoryGirl.create(:shop_item)
        expect_any_instance_of(ShopItem).not_to receive(:move)
        get :move_to_portfolio, params: { "id" => -1 }
      end

      it "should show an error message when unsuccessful because the ShopItem cannot be found" do
        i = FactoryGirl.create(:shop_item)
        get :move_to_portfolio, params: { "id" => -1 }
        expect(flash[:error]).to eq("Unable to find that shop item.")
        expect(flash[:info]).to be_blank
      end

      it "should show an error message when unsuccessful because the PortfolioItem cannot be created" do
        i = FactoryGirl.create(:shop_item)
        expect_any_instance_of(ShopItem).to receive(:move).once.and_return(-1)
        get :move_to_portfolio, params: { "id" => i[:id] }
        expect(flash[:error]).to eq("Unable to create portfolio item. Please create and delete manually.")
        expect(flash[:info]).to be_blank
      end

      it "should show an error message when unsuccessful because the ShopItem cannot be destroyed" do
        i = FactoryGirl.create(:shop_item)
        expect_any_instance_of(ShopItem).to receive(:move).once.and_return(0)
        get :move_to_portfolio, params: { "id" => i[:id] }
        expect(flash[:error]).to eq("Item copied, but unable to delete shop item. Please delete manually.")
        expect(flash[:info]).to be_blank
      end

      it "should show an info message when successful" do
        i = FactoryGirl.create(:shop_item)
        expect_any_instance_of(ShopItem).to receive(:move).once.and_return(1)
        get :move_to_portfolio, params: { "id" => i[:id] }
        expect(flash[:error]).to be_blank
        expect(flash[:info]).to eq("Item moved successfully.")
      end
    end
  end
end
