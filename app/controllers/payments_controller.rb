class PaymentsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:webhook]

    def success
    end

    # Webhook endpoint is set for production so the state changes will not work 
    # if testing locally unless you run `stripe listen --forward-to localhost:3000/payments/webhook`
    # at the same time as the server is running

  def webhook
    payment_id = params[:data][:object][:payment_intent]
    payment = Stripe::PaymentIntent.retrieve(payment_id)
    listing_id = payment.metadata.listing_id
    user_id = payment.metadata.user_id
    seller_id = payment.metadata.seller_id
    listing = Listing.find(listing_id)
    listing.sold = true
    listing.save
    head 200
  end
end

# implement auto messaging to seller in webhook if possible otherwise JS event listener for sold boolean change
# message.create(from user_id to seller_id)(body: "blah blah blah")
# message.save