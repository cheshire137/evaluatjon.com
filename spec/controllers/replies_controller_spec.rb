require 'rails_helper'

RSpec.describe RepliesController, type: :controller do
  let(:rating) { create(:rating) }
  let(:user) { create(:user) }

  describe "GET index" do
    before do
      @good_reply = create(:reply, rating: rating)
      @bad_reply = create(:reply)
    end
    let(:make_request) { ->{ get :index, rating_id: rating } }

    it 'includes replies to specified rating' do
      make_request.call
      expect(assigns(:replies)).to include(@good_reply)
    end

    it 'excludes replies not to the specified rating' do
      make_request.call
      expect(assigns(:replies)).to_not include(@bad_reply)
    end
  end

  describe "GET show" do
    let(:reply) { create(:reply, rating: rating) }
    let(:make_request) { ->{ get :show, id: reply, rating_id: rating } }

    it "assigns the requested reply as @reply" do
      make_request.call
      expect(assigns(:reply)).to eq(reply)
    end
  end

  describe "POST create" do
    let(:make_request) {
      ->{ post :create, {reply: attributes_for(:reply), rating_id: rating,
                         email: user.email, token: user.auth_token} }
    }

    describe 'when reply saves' do
      context 'when authenticated' do
        it "creates a new Reply" do
          expect(make_request).to change(Reply, :count).by(1)
        end

        it "assigns a newly created reply as @reply" do
          make_request.call
          expect(assigns(:reply)).to be_a(Reply)
          expect(assigns(:reply)).to be_persisted
        end

        it "responds successfully" do
          make_request.call
          expect(response).to be_success
        end
      end
    end

    context 'when reply does not save' do
      before do
        allow_any_instance_of(Reply).to receive(:save).and_return(false)
      end

      it "assigns a newly created but unsaved reply as @reply" do
        make_request.call
        expect(assigns(:reply)).to be_a_new(Reply)
      end

      it "does not respond successfully" do
        make_request.call
        expect(response).to_not be_success
      end
    end
  end

  describe "PUT update" do
    let(:reply) { create(:reply, rating: rating) }
    let(:make_request) {
      ->{ put :update, id: reply, reply: reply_attrs, rating_id: rating,
                       email: email, token: token }
    }

    context 'when reply saves' do
      let(:reply_attrs) { {message: 'Some cool message!'} }

      context 'when authenticated' do
        let(:email) { user.email }
        let(:token) { user.auth_token }

        it "updates the requested reply" do
          make_request.call
          expect(reply.reload.message).to eq(reply_attrs[:message])
        end

        it "assigns the requested reply as @reply" do
          make_request.call
          expect(assigns(:reply)).to eq(reply)
        end

        it "responds successfully" do
          make_request.call
          expect(response).to be_success
        end
      end
    end

    context 'when reply does not save' do
      before do
        allow_any_instance_of(Reply).to receive(:save).and_return(false)
      end
      let(:reply_attrs) { {message: 'Not gonna happen.'} }

      context 'when authenticated' do
        let(:email) { user.email }
        let(:token) { user.auth_token }

        it 'does not change the reply message' do
          before_value = reply.message
          make_request.call
          expect(reply.reload.message).to eq(before_value)
        end

        it "assigns the reply as @reply" do
          make_request.call
          expect(assigns(:reply)).to eq(reply)
        end

        it "does not respond successfully" do
          make_request.call
          expect(response).to_not be_success
        end
      end

      context 'when not authenticated' do
        let(:email) { nil }
        let(:token) { nil }

        it 'does not change the reply message' do
          before_value = reply.message
          make_request.call
          expect(reply.reload.message).to eq(before_value)
        end

        it 'does not assign the reply' do
          make_request.call
          expect(assigns(:reply)).to eq(nil)
        end

        it 'responds with unauthorized code' do
          make_request.call
          expect(response.code).to eq('401')
        end
      end
    end
  end

  describe "DELETE destroy" do
    let(:reply) { create(:reply, rating: rating) }
    let(:make_request) {
      ->{ delete :destroy, id: reply, rating_id: rating,
                           email: email, token: token }
    }

    context 'when not authenticated' do
      let(:email) { nil }
      let(:token) { nil }

      it 'does not delete the reply' do
        make_request.call
        expect(Reply.exists?(reply.id)).to eq(true)
      end

      it 'does not respond successfully' do
        make_request.call
        expect(response).to_not be_success
      end
    end

    context 'when authenticated' do
      let(:email) { user.email }
      let(:token) { user.auth_token }

      it "destroys the requested reply" do
        make_request.call
        expect(Reply.exists?(reply.id)).to eq(false)
      end

      it "responds successfully" do
        make_request.call
        expect(response).to be_success
      end
    end
  end
end
