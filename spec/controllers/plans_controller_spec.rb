
# frozen_string_literal: true

require 'rails_helper'
require 'devise'

RSpec.describe PlansController, type: :controller do
  let(:user) {create(:user, :admin)}
  let(:plan) {create(:plan)}
  before(:each) do
    sign_in user
  end

  describe ' plans#index' do

    context 'when plan is present' do
      it 'will get ndex of a plan' do
        get :index, params: {plan: plan}
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
        patch :update, params: {plan: {name: "Hello", monthly_fee: 3} ,id: plan.id }
        plan.reload
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eql('Plan was successfully updated.')
      end
    end

    context 'plan is not updated' do
      it 'should not edit a plan with invalid params' do
        patch :update, params: {plan: {name: nil, monthly_fee: nil } ,id: plan.id }
        expect(response).to have_http_status(200)
        expect(flash[:notice]).to eql('Plan was not successfully updated.')
      end

      it 'should not render edit when user is a buyer' do
        buyer = create(:user, :Buyer)
        patch :update, params: {plan: {name: "Hello", monthly_fee: 3} ,id: plan.id }
        expect(response).to have_http_status(302)

      end
    end
  end

  describe '#create_plan when usertype admin' do
    before do
      allow_any_instance_of(StripePlan::PriceCreator).to receive(:call).and_return(plan)
    end

    context 'when all params are present' do
      it 'will create a plan' do
        StripeMock.start
        product = Stripe::Product.create({ name: plan.name })
        plan.product_id = product.id
        price = StripePlan::PriceCreator.call(plan)
        plan.price_id = price.id
        post :create,params: {plan: {monthly_fee:plan.monthly_fee, name:plan.name}}
      end
    end

    context 'when params are missing' do

      it 'will not create a plan' do
        StripeMock.start
        product = Stripe::Product.create({ name: plan.name })
        plan.product_id = product.id
        price = StripePlan::PriceCreator.call(plan)
        plan.price_id = price.id
        @request.env['HTTP_REFERER'] = root_url
        post :create,params: {plan: {monthly_fee:nil, name:plan.name}}

      end
    end
  end

  describe 'plans#destroy' do
    context 'plan is deleted' do

      it 'should delete a plan ' do
        delete :destroy,  params: {id: plan.id }
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eql('Plan was successfully destroyed.')
      end
    end

    context 'Plan is not deleted' do
      let(:plan1) {build_stubbed(:plan)}

      it 'should not delete a plan' do
        allow(plan1).to receive(:destroy).and_return(false)
        allow(Plan).to receive(:find).and_return(plan1)
        delete :destroy,  params: {id: plan1.id }
        expect(response).to have_http_status(200)
        expect(flash[:notice]).to eql('Plan was not successfully deleted.')
      end
    end
  end


end
