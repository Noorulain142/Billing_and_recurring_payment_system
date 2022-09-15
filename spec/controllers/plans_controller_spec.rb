# frozen_string_literal: true

require 'rails_helper'
require 'devise'

RSpec.describe PlansController, type: :controller do
  let(:user) { create(:user, :admin) }
  let(:buyer) { create(:user, :Buyer) }
  let(:plan) { create(:plan) }
  let(:plan1) { build_stubbed(:plan) }
  before(:each) do
    sign_in user
  end

  describe ' plans#index' do
    context 'when plan is present' do
      it 'will get ndex of a plan' do
        get :index, params: { plan: plan }
        expect(response).to have_http_status(200)
        expect(response).to render_template 'index'
      end
    end

    context 'when plan is not present' do
      it 'will not get ndex of a plan' do
        @request.env['HTTP_REFERER'] = root_url
        get :index, params: { plan: nil }
      end
    end
  end

  describe 'plans#new' do
    before do
      get :new
    end

    context 'check if plan created or not' do
      it 'new plan not created' do
        expect(assigns(:plan)).not_to eq nil
      end

      it 'new plan created' do
        expect(assigns(:plan)).to be_a_new(Plan)
      end
    end
  end

  describe 'plans#update' do
    context 'plan is updated' do
      it 'should edit a plan when user is a admin' do
        patch :update, params: { plan: { name: 'Hello', monthly_fee: 3 }, id: plan.id }
        plan.reload
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eql('Plan was successfully updated.')
      end
    end

    context 'plan is not updated when params are invalid' do
      it 'should not edit a plan with invalid params' do
        patch :update, params: { plan: { name: nil, monthly_fee: nil }, id: plan.id }
        expect(response).to have_http_status(200)
        expect(flash[:notice]).to eql('Plan was not successfully updated.')
      end
    end

    context 'plan is not updated user is a buyer' do
      before do
        sign_in buyer
      end
      it 'should not render edit when user is a buyer' do
        patch :update, params: { plan: { name: 'Hello', monthly_fee: 3 }, id: plan.id }

        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eql('You are not authorized to perform this action.')
      end

    end

    context 'plan not updated because user not present' do
      before do
        sign_out user
      end
      it 'should not render edit when user is not present' do
        patch :update, params: { plan: { name: 'Hello', monthly_fee: 3 }, id: plan.id }

        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eql('You need to sign in or sign up before continuing.')
      end
    end

  end

  describe '#create_plan' do
    before do
      allow_any_instance_of(StripePlan::PriceCreator).to receive(:call).and_return(plan)
      StripeMock.start
      product = Stripe::Product.create({ name: plan.name })
      plan.product_id = product.id
      price = StripePlan::PriceCreator.call(plan)
      plan.price_id = price.id
    end

    context 'when all params are present' do
      before do
        post :create, params: { plan: { monthly_fee: plan.monthly_fee, name: plan.name } }
      end
      it 'will create a plan' do
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eql('Plan was successfully created.')
      end
    end

    context 'when params are missing' do
      before do
        @request.env['HTTP_REFERER'] = root_url
        post :create, params: { plan: { monthly_fee: nil, name: plan.name } }
      end

      it 'will not create a plan' do
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eql('Plan not created')


      end
    end

    context 'plan not created because user not present' do
      before do
        sign_out user
        @request.env['HTTP_REFERER'] = root_url
        post :create, params: { plan: { monthly_fee: nil, name: plan.name } }
      end

      it 'should not render create when user is not present' do

        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eql('You need to sign in or sign up before continuing.')
      end
    end

    context 'when usertype is buyer' do
      before do
        sign_in buyer
        @request.env['HTTP_REFERER'] = root_url
        post :create, params: { plan: { monthly_fee: nil, name: plan.name } }
      end

      it 'will not create a plan' do
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eql('You are not authorized to perform this action.')
      end
    end
  end

  describe 'plans#destroy' do
    context 'plan is deleted' do
      it 'should delete a plan ' do
        delete :destroy,  params: { id: plan.id }
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eql('Plan was successfully destroyed.')
      end
    end

    context 'Plan is not deleted' do
      before do
        allow(plan1).to receive(:destroy).and_return(false)
        allow(Plan).to receive(:find).and_return(plan1)
      end
      it 'should not delete a plan' do
        delete :destroy, params: { id: plan1.id }
        expect(response).to have_http_status(200)
        expect(flash[:notice]).to eql('Plan was not successfully deleted.')
      end
    end

    context 'plan not destroyed because user not present' do
      before do
        sign_out user
      end
      it 'should not render destroy when user is not present' do
        delete :destroy, params: { id: plan.id }
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eql('You need to sign in or sign up before continuing.')
      end
    end

    context 'plan not destroyed because user is not admin' do
      before do
        sign_in buyer
      end
      it 'should not render edit when user is not admin' do
        delete :destroy, params: { id: plan.id }
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eql('You are not authorized to perform this action.')
      end
    end
  end
end
