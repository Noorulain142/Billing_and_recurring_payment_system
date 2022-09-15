# frozen_string_literal: true

require 'rails_helper'
require 'devise'
require 'ostruct'

RSpec.describe Purchase::CheckoutsController, type: :controller do
  let(:buyer) { create(:user, :Buyer) }
  let(:admin) { create(:user, :admin) }
  let(:plan1) { create(:plan) }
  let(:stripe_mock) { StripeMock.create_test_helper }
  before(:each) do
    sign_in buyer
  end
  let(:session_checkout) do
    {
      customer: 123,
      client_reference_id: 2,
      success_url: @root_url,
      cancel_url: pricing_url,
      payment_method_types: ['card'],
      mode: 'subscription',
      customer_email: buyer.email,
      line_items: [{
        quantity: 1,
        price: 123
      }],
      url: {}
    }
  end

  let(:subscription) do
    {
      id: '1',
      plan_id: plan1, user_id: buyer, status: 'active',
      current_period_start: 1_662_978_530,
      current_period_end: 1_665_570_530,
      interval: 'month',
      customer_id: 1, subscription_id: 1
    }
  end

  let(:customer) do
    { id: 1,
      plan_id: plan1, user_id: buyer, email: buyer.email, name: buyer.name }
  end

  describe '#create_subscription' do
    context 'when session is present' do
      before do
        StripeMock.start
        plan_obj_id = plan1.id
        @root_url = "#{root_url}purchase/checkouts/success?session_id={CHECKOUT_SESSION_ID}"
        @pricing_url = pricing_url
        allow_any_instance_of(StripeCheckout::CheckoutCreator).to receive(:call).and_return(session_checkout)
        session1 = StripeCheckout::CheckoutCreator.call(buyer, plan1, @root_url, @pricing_url)
        post :create, params: { session: session1, plan_id: plan_obj_id }
      end
      it 'will create a subscription' do
        expect(response).to have_http_status(302)
      end
    end
  end

  describe '#do not create_subscription' do

    context 'when session is not present ' do
      before do
        plan_obj_id = plan1.id
        allow_any_instance_of(StripeCheckout::CheckoutCreator).to receive(:call).and_return(false)
        session = nil
        post :create, params: { session: session, plan_id: plan_obj_id }
      end
      it 'will not create a subscription' do
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eql('session parameters missing')
      end
    end

    context 'when buyer is not present' do
      before do
        sign_out buyer
        allow_any_instance_of(StripeCheckout::CheckoutCreator).to receive(:call).and_return(false)
        plan_obj_id = plan1.id
        session1 = StripeCheckout::CheckoutCreator.call(buyer, plan1, @root_url, @pricing_url)
        post :create, params: { session: session1, plan_id: plan_obj_id }
      end
      it 'will not create a subscription when user is not present' do
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eql('You need to sign in or sign up before continuing.')
      end
    end

    context 'when user is not buyer' do
      before do
        sign_in admin
        allow_any_instance_of(StripeCheckout::CheckoutCreator).to receive(:call).and_return(false)
        plan_obj_id = plan1.id
        session1 = StripeCheckout::CheckoutCreator.call(buyer, plan1, @root_url, @pricing_url)
        post :create, params: { session: session1, plan_id: plan_obj_id }
      end

      it 'will not create a subscription when user is not buyer' do

        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eql('You are not authorized to perform this action.')
      end
    end

  end

  describe '#successful_subscription' do

    context 'when session is created' do
      before do
        StripeMock.start
        request.session
        stripe_session_mock = @stripe_test_helper.create_coupon(id: '1', subscription: subscription, customer: customer)
        allow(Stripe::Checkout::Session).to receive(:retrieve).and_return(stripe_session_mock)
        allow(Stripe::Subscription).to receive(:retrieve).and_return(stripe_session_mock.subscription)
        sub = Stripe::Subscription.retrieve(
          stripe_session_mock.subscription
        )
        allow_any_instance_of(StripeCheckout::SubscriptionCreator).to receive(:call).and_return(subscription)
        StripeCheckout::SubscriptionCreator.call(plan1, sub, buyer)
        allow(Stripe::Customer).to receive(:retrieve).and_return(stripe_session_mock.customer)
        Stripe::Customer.retrieve(stripe_session_mock.customer)
        get :success, params: { subscription: subscription, plan_id: plan1 }
      end

      it 'will allow successful subscription' do
        expect(response).to have_http_status(200)
        expect(response).to render_template 'success'
      end
    end
  end

  describe '#unsuccessful_subscription' do

    context 'when buyer is not present' do
      before do
        sign_out buyer
        StripeMock.start
        request.session
        stripe_session_mock = @stripe_test_helper.create_coupon(id: '1', subscription: subscription, customer: customer)
        allow(Stripe::Checkout::Session).to receive(:retrieve).and_return(stripe_session_mock)
        allow(Stripe::Subscription).to receive(:retrieve).and_return(stripe_session_mock.subscription)
        sub = Stripe::Subscription.retrieve(
          stripe_session_mock.subscription
        )
        allow_any_instance_of(StripeCheckout::SubscriptionCreator).to receive(:call).and_return(subscription)
        StripeCheckout::SubscriptionCreator.call(plan1, sub, buyer)
        allow(Stripe::Customer).to receive(:retrieve).and_return(stripe_session_mock.customer)
        Stripe::Customer.retrieve(stripe_session_mock.customer)
        get :success, params: { subscription: subscription, plan_id: plan1 }
      end

      it 'will not allow successful subscription when user is not present' do
        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eql('You need to sign in or sign up before continuing.')
      end
    end

    context 'when user is not buyer' do
      before do
        sign_in admin
        StripeMock.start
        request.session
        stripe_session_mock = @stripe_test_helper.create_coupon(id: '1', subscription: subscription, customer: customer)
        allow(Stripe::Checkout::Session).to receive(:retrieve).and_return(stripe_session_mock)
        allow(Stripe::Subscription).to receive(:retrieve).and_return(stripe_session_mock.subscription)
        sub = Stripe::Subscription.retrieve(
          stripe_session_mock.subscription
        )
        allow_any_instance_of(StripeCheckout::SubscriptionCreator).to receive(:call).and_return(subscription)
        StripeCheckout::SubscriptionCreator.call(plan1, sub, buyer)
        allow(Stripe::Customer).to receive(:retrieve).and_return(stripe_session_mock.customer)
        Stripe::Customer.retrieve(stripe_session_mock.customer)

      end

      it 'will not allow successful subscription when user is not buyer' do
        get :success, params: { subscription: subscription, plan_id: plan1 }

        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eql('You are not authorized to perform this action.')
      end
    end

  end

end
