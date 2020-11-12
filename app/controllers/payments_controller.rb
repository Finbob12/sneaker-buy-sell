class PaymentsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:webhook]
    def success
    end

    def webhook
        event = Stripe::Event.construct_from(
            params.to_unsafe_h
          )
          case event.type
          when 'payment_intent.succeeded'
              payment_intent = event.data.object
              buyer = User.find(payment_intent.metadata.user_id)
              listing = Listing.find(payment_intent.metadata.listing_id)
              listing.sold = true
              listing.save
          when 'payment_method.attached'
              payment_method = event.data.object
          else
              head :no_content
              return
          end
        head :no_content
    end
end