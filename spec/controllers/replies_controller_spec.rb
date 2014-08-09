require 'rails_helper'

RSpec.describe RepliesController, type: :controller do
  let(:rating) { Rating.create!(dimension: 'coolness', comment: 'Very neat!',
                                rater: 'Jimbob', stars: 6.5) }
  let(:user) { User.create!(email: 'funny@example.com', password: 'password',
                            password_confirmation: 'password') }
  let(:valid_attributes) {
    {rating_id: rating.id, message: 'My in-depth retort.', user_id: user.id}
  }

  let(:invalid_attributes) {
    {rating_id: nil, message: '', user_id: nil}
  }

  describe "GET index" do
    it "assigns all replies as @replies" do
      reply = Reply.create!(valid_attributes)
      get :index, rating_id: rating
      expect(assigns(:replies)).to eq([reply])
    end
  end

  describe "GET show" do
    it "assigns the requested reply as @reply" do
      reply = Reply.create!(valid_attributes)
      get :show, {id: reply, rating_id: rating}
      expect(assigns(:reply)).to eq(reply)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      context 'when authenticated' do
        it "creates a new Reply" do
          expect {
            post :create, {reply: valid_attributes, rating_id: rating,
                           email: user.email, token: user.auth_token}
          }.to change(Reply, :count).by(1)
        end

        it "assigns a newly created reply as @reply" do
          post :create, {reply: valid_attributes, rating_id: rating,
                         email: user.email, token: user.auth_token}
          expect(assigns(:reply)).to be_a(Reply)
          expect(assigns(:reply)).to be_persisted
        end

        it "responds successfully" do
          post :create, {reply: valid_attributes, rating_id: rating,
                         email: user.email, token: user.auth_token}
          expect(response).to be_success
        end
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved reply as @reply" do
        post :create, {reply: invalid_attributes, rating_id: rating,
                       email: user.email, token: user.auth_token}
        expect(assigns(:reply)).to be_a_new(Reply)
      end

      it "does not respond successfully" do
        post :create, {reply: invalid_attributes, rating_id: rating,
                       email: user.email, token: user.auth_token}
        expect(response).to_not be_success
      end
    end
  end

  describe "PUT update" do
    let(:reply) { Reply.create!(valid_attributes) }

    describe "with valid params" do
      let(:new_attributes) { {message: 'Some cool message!'} }

      context 'when authenticated' do
        it "updates the requested reply" do
          put :update, {id: reply, reply: new_attributes, rating_id: rating,
                        email: user.email, token: user.auth_token}
          reply.reload
          skip("Add assertions for updated state")
        end

        it "assigns the requested reply as @reply" do
          put :update, {id: reply, reply: valid_attributes, rating_id: rating,
                        email: user.email, token: user.auth_token}
          expect(assigns(:reply)).to eq(reply)
        end

        it "responds successfully" do
          put :update, {id: reply, reply: valid_attributes, rating_id: rating,
                        email: user.email, token: user.auth_token}
          expect(response).to be_success
        end
      end
    end

    describe "with invalid params" do
      it "assigns the reply as @reply" do
        put :update, {id: reply, reply: invalid_attributes, rating_id: rating,
                      email: user.email, token: user.auth_token}
        expect(assigns(:reply)).to eq(reply)
      end

      it "does not respond successfully" do
        put :update, {id: reply, reply: invalid_attributes, rating_id: rating,
                      email: user.email, token: user.auth_token}
        expect(response).to_not be_success
      end
    end
  end

  describe "DELETE destroy" do
    before { @reply = Reply.create!(valid_attributes) }

    context 'when not authenticated' do
      it 'does not delete the reply' do
        expect {
          delete :destroy, {id: @reply, rating_id: rating}
        }.to_not change(Reply, :count)
      end

      it 'does not respond successfully' do
        delete :destroy, {id: @reply, rating_id: rating}
        expect(response).to_not be_success
      end
    end

    context 'when authenticated' do
      it "destroys the requested reply" do
        expect {
          delete :destroy, {id: @reply, rating_id: rating,
                            email: user.email, token: user.auth_token}
        }.to change(Reply, :count).by(-1)
      end

      it "responds successfully" do
        delete :destroy, {id: @reply, rating_id: rating,
                          email: user.email, token: user.auth_token}
        expect(response).to be_success
      end
    end
  end
end
