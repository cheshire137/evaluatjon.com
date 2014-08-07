require 'rails_helper'

RSpec.describe RatingsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Rating. As you add validations to Rating, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RatingsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all ratings as @ratings" do
      rating = Rating.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:ratings)).to eq([rating])
    end
  end

  describe "GET show" do
    it "assigns the requested rating as @rating" do
      rating = Rating.create! valid_attributes
      get :show, {:id => rating.to_param}, valid_session
      expect(assigns(:rating)).to eq(rating)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Rating" do
        expect {
          post :create, {:rating => valid_attributes}, valid_session
        }.to change(Rating, :count).by(1)
      end

      it "assigns a newly created rating as @rating" do
        post :create, {:rating => valid_attributes}, valid_session
        expect(assigns(:rating)).to be_a(Rating)
        expect(assigns(:rating)).to be_persisted
      end

      it "redirects to the created rating" do
        post :create, {:rating => valid_attributes}, valid_session
        expect(response).to redirect_to(Rating.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved rating as @rating" do
        post :create, {:rating => invalid_attributes}, valid_session
        expect(assigns(:rating)).to be_a_new(Rating)
      end

      it "re-renders the 'new' template" do
        post :create, {:rating => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested rating" do
        rating = Rating.create! valid_attributes
        put :update, {:id => rating.to_param, :rating => new_attributes}, valid_session
        rating.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested rating as @rating" do
        rating = Rating.create! valid_attributes
        put :update, {:id => rating.to_param, :rating => valid_attributes}, valid_session
        expect(assigns(:rating)).to eq(rating)
      end

      it "redirects to the rating" do
        rating = Rating.create! valid_attributes
        put :update, {:id => rating.to_param, :rating => valid_attributes}, valid_session
        expect(response).to redirect_to(rating)
      end
    end

    describe "with invalid params" do
      it "assigns the rating as @rating" do
        rating = Rating.create! valid_attributes
        put :update, {:id => rating.to_param, :rating => invalid_attributes}, valid_session
        expect(assigns(:rating)).to eq(rating)
      end

      it "re-renders the 'edit' template" do
        rating = Rating.create! valid_attributes
        put :update, {:id => rating.to_param, :rating => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested rating" do
      rating = Rating.create! valid_attributes
      expect {
        delete :destroy, {:id => rating.to_param}, valid_session
      }.to change(Rating, :count).by(-1)
    end

    it "redirects to the ratings list" do
      rating = Rating.create! valid_attributes
      delete :destroy, {:id => rating.to_param}, valid_session
      expect(response).to redirect_to(ratings_url)
    end
  end

end
