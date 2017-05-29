require 'spec_helper'

describe Admin::PortfolioController, type: :controller do
  context "when not logged in" do
    before do
      PortfolioItem.delete_all
      @item = FactoryGirl.create(:portfolio_item)
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
        put 'create', portfolio_item: @item
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "GET 'edit'" do
      it "should redirect to the login page" do
        get 'edit', id: @item.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "POST 'update'" do
      it "should redirect to the login page" do
        post 'update', id: @item.id
        expect(response).to redirect_to new_user_session_path
        expect(PortfolioItem.find(@item.id)).to eq(@item)
      end
    end

    context "POST 'delete'" do
      it "should redirect to the login page" do
        delete 'destroy', id: @item.id
        expect(response).to redirect_to new_user_session_path
        expect(PortfolioItem.find(@item.id)).to eq(@item)
      end
    end

    context "GET 'move_to_shop'" do
      it "should redirect to the login page" do
        get 'move_to_shop', id: @item.id
        expect(response).to redirect_to new_user_session_path
        expect(PortfolioItem.find(@item.id)).to eq(@item)
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
        expect(response.status).to eq(200)

        expect(assigns[:items].collect(&:class)).to eq([
          PortfolioItem, PortfolioItem,
          PortfolioItem, PortfolioItem,
          PortfolioItem
        ])
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
        expect(response.status).to eq(302)
        expect(PortfolioItem.all).to include(@item)
      end
    end

    context "GET edit" do
      it "should load the given PortfolioItem" do
        get 'edit', id: @item.id
        expect(assigns[:item]).to eq(@item)
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
        expect(@item.title).to eq("My New Title")
        expect(@item.description).to eq("This has been modified.")
      end
    end

    context "POST delete" do
      it "should delete the given PortfolioItem" do
        expect { PortfolioItem.find(@item_id) }.not_to raise_error # ActiveRecord::RecordNotFound
        delete 'destroy', id: @item_id
        expect { PortfolioItem.find(@item_id) }.to     raise_error # ActiveRecord::RecordNotFound
      end
    end

    context "GET move_to_shop" do
      before(:each) do
        ShopItem.delete_all
        PortfolioItem.delete_all
      end

      it "should not call PortfolioItem#move when the PortfolioItem cannot be found" do
        i = FactoryGirl.create(:portfolio_item)
        expect_any_instance_of(PortfolioItem).not_to receive(:move)
        get :move_to_shop, { "id" => -1 }
      end

      it "should show an error message when unsuccessful because the PortfolioItem cannot be found" do
        i = FactoryGirl.create(:portfolio_item)
        get :move_to_shop, { "id" => -1 }
        expect(flash[:error]).to eq("Unable to find that portfolio item.")
        expect(flash[:info]).to be_blank
      end

      it "should show an error message when unsuccessful because the ShopItem cannot be created" do
        i = FactoryGirl.create(:portfolio_item)
        expect_any_instance_of(PortfolioItem).to receive(:move).once.and_return(-1)
        get :move_to_shop, { "id" => i[:id] }
        expect(flash[:error]).to eq("Unable to create shop item. Please create and delete manually.")
        expect(flash[:info]).to be_blank
      end

      it "should show an error message when unsuccessful because the PortfolioItem cannot be destroyed" do
        i = FactoryGirl.create(:portfolio_item)
        expect_any_instance_of(PortfolioItem).to receive(:move).once.and_return(0)
        get :move_to_shop, { "id" => i[:id] }
        expect(flash[:error]).to eq("Item copied, but unable to delete portfolio item. Please delete manually.")
        expect(flash[:info]).to be_blank
      end

      it "should show an info message when successful" do
        i = FactoryGirl.create(:portfolio_item)
        expect_any_instance_of(PortfolioItem).to receive(:move).once.and_return(1)
        get :move_to_shop, { "id" => i[:id] }
        expect(flash[:error]).to be_blank
        expect(flash[:info]).to eq("Item moved successfully.")
      end
    end
  end
end
