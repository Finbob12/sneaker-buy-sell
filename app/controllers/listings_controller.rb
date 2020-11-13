class ListingsController < ApplicationController
    before_action :authenticate_user!, except: [:index]
    before_action :listing_params, only: [:create]
    before_action :set_listing, only: [:show, :edit, :update, :destroy]

    def index
        @listings = Listing.all
    end

    def show
        if @listing.sold then redirect_to listings_path
          elsif current_user.id != @listing.user.id
            @payment_button = true
        session = Stripe::Checkout::Session.create(
            payment_method_types: ['card'],
            customer_email: current_user.email,
            line_items: [{
                name: (@listing.brand + " " + @listing.style),
                description: @listing.description,
                amount: @listing.price * 100,
                currency: 'aud',
                quantity: 1,
            }],
            payment_intent_data: {
                metadata: {
                    user_id: current_user.id,
                    listing_id: @listing.id
                }
            },
            success_url: "#{root_url}payments/success?userId=#{current_user.id}&listingId=#{@listing.id}",
            cancel_url: "#{root_url}listings"
        )
    
        @session_id = session.id
        end
    end

    def new 
        @listing = Listing.new
    end
    
    def create
        @listing = current_user.listings.create(listing_params)
        if @listing.valid?
            @listing.save!
            redirect_to listing_path(@listing.id)
        else
            flash.now[:messages] = @listing.errors.full_messages
            render :new
        end
end

    def edit
    end

    def update
        if @listing.update(listing_params) && @listing.valid?
            @listing.save!
            redirect_to @listing
        else
            flash.now[:messages] = @listing.errors.full_messages
            render "edit"
        end
    end

    def destroy
        if @listing.present?
          @listing.destroy!
        end
        redirect_to account_path, notice: "Listing was successfully deleted"
    end

    def manage_listings
        @listings = Listing.all
    end
    
private

    def listing_params
        params.require(:listing).permit(:brand, :style, :size, :price, :description, :picture)
    end

    def set_listing
        @listing = Listing.find(params[:id])
    end
end