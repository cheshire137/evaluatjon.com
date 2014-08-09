require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  let(:valid_attributes) {
    {dimension: 'coolness', comment: 'Very neat!', rater: 'Jimbob',
     stars: '0.5'}
  }

  let(:invalid_attributes) {
    {dimension: nil, comment: nil, rater: nil, stars: -3}
  }

  describe "GET index" do
    it "assigns all ratings as @ratings" do
      rating = Rating.create!(valid_attributes)
      get :index
      expect(assigns(:ratings)).to eq([rating])
    end
  end

  describe "GET show" do
    it "assigns the requested rating as @rating" do
      rating = Rating.create!(valid_attributes)
      get :show, id: rating
      expect(assigns(:rating)).to eq(rating)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      let(:make_request) { ->{ post :create, rating: valid_attributes } }
      it "creates a new Rating" do
        expect(make_request).to change(Rating, :count).by(1)
      end

      it "assigns a newly created rating as @rating" do
        make_request.call
        expect(assigns(:rating)).to be_a(Rating)
        expect(assigns(:rating)).to be_persisted
      end

      it "responds successfully" do
        make_request.call
        expect(response).to be_success
      end

      it 'creates a rating with specified parameters' do
        make_request.call
        expect(Rating.last.stars).to eq(0.5)
        expect(Rating.last.dimension).to eq('coolness')
        expect(Rating.last.comment).to eq('Very neat!')
        expect(Rating.last.rater).to eq('Jimbob')
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved rating as @rating" do
        post :create, {rating: invalid_attributes}
        expect(assigns(:rating)).to be_a_new(Rating)
      end

      it "does not load successfully" do
        post :create, {rating: invalid_attributes}
        expect(response.code).to eq('422')
      end
    end
  end

  describe "PUT update" do
    before do
      @user = User.create!(email: 'neato@example.com', password: 'password',
                           password_confirmation: 'password')
    end
    let(:email) { @user.email }
    let(:token) { @user.auth_token }

    describe "with valid params" do
      let(:new_attributes) { {stars: 5, rater: 'Cool Guy #3'} }

      it "updates the requested rating" do
        rating = Rating.create!(valid_attributes)
        put :update, {id: rating, email: email, token: token,
                      rating: new_attributes}
        rating.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested rating as @rating" do
        rating = Rating.create!(valid_attributes)
        put :update, {id: rating, email: email, token: token,
                      rating: valid_attributes}
        expect(assigns(:rating)).to eq(rating)
      end

      it "responds successfully" do
        rating = Rating.create!(valid_attributes)
        put :update, {id: rating, email: email, token: token,
                      rating: valid_attributes}
        expect(response).to be_success
      end
    end

    describe "with invalid params" do
      it "assigns the rating as @rating" do
        rating = Rating.create!(valid_attributes)
        put :update, {id: rating, email: email, token: token,
                      rating: invalid_attributes}
        expect(assigns(:rating)).to eq(rating)
      end

      it "does not respond successfully" do
        rating = Rating.create!(valid_attributes)
        put :update, {id: rating, email: email, token: token,
                      rating: invalid_attributes}
        expect(response.code).to eq('422')
      end
    end
  end
end
