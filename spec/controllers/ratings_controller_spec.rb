require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  describe "GET index" do
    before { @rating = create(:rating) }
    let(:make_request) { ->{ get :index } }

    it "assigns all ratings as @ratings" do
      make_request.call
      expect(assigns(:ratings)).to eq([@rating])
    end
  end

  describe "GET show" do
    let(:rating) { create(:rating) }
    let(:make_request) { ->{ get :show, id: rating } }

    it "assigns the requested rating as @rating" do
      make_request.call
      expect(assigns(:rating)).to eq(rating)
    end
  end

  describe "POST create" do
    let(:make_request) { ->{ post :create, rating: rating_attrs } }
    let(:rating_attrs) {
      {stars: '0.5', dimension: 'coolness', comment: 'Very neat!',
       rater: 'Jimbob'}
    }

    context 'when the rating saves' do
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

    context 'when rating does not save' do
      before do
        allow_any_instance_of(Rating).to receive(:save).and_return(false)
      end

      it "assigns a newly created but unsaved rating as @rating" do
        make_request.call
        expect(assigns(:rating)).to be_a_new(Rating)
      end

      it "does not load successfully" do
        make_request.call
        expect(response.code).to eq('422')
      end
    end
  end

  describe "PUT update" do
    let(:user) { create(:user) }
    let(:rating) { create(:rating) }
    let(:make_request) {
      ->{ put :update, id: rating, email: email, token: token,
                       rating: rating_attrs }
    }
    let(:rating_attrs) { {stars: 5, rater: 'Cool Guy #3'} }

    context 'when authenticated' do
      let(:email) { user.email }
      let(:token) { user.auth_token }

      context 'when rating saves' do
        it "updates the requested rating's stars" do
          make_request.call
          expect(rating.reload.stars).to eq(rating_attrs[:stars])
        end

        it "updates the requested rating's rater" do
          make_request.call
          expect(rating.reload.rater).to eq(rating_attrs[:rater])
        end

        it "assigns the requested rating as @rating" do
          make_request.call
          expect(assigns(:rating)).to eq(rating)
        end

        it "responds successfully" do
          make_request.call
          expect(response).to be_success
        end
      end

      context 'when rating does not save' do
        before do
          allow_any_instance_of(Rating).to receive(:save).and_return(false)
        end

        it "does not update the requested rating's stars" do
          before_value = rating.stars
          make_request.call
          expect(rating.reload.stars).to eq(before_value)
        end

        it "does not update the requested rating's rater" do
          before_value = rating.rater
          make_request.call
          expect(rating.reload.rater).to eq(before_value)
        end

        it "assigns the rating as @rating" do
          make_request.call
          expect(assigns(:rating)).to eq(rating)
        end

        it "does not respond successfully" do
          make_request.call
          expect(response.code).to eq('422')
        end
      end
    end

    context 'when not authenticated' do
      let(:email) { nil }
      let(:token) { nil }

      it "does not assign the rating as @rating" do
        make_request.call
        expect(assigns(:rating)).to eq(nil)
      end

      it 'responds with unauthorized code' do
        make_request.call
        expect(response.code).to eq('401')
      end
    end
  end
end
