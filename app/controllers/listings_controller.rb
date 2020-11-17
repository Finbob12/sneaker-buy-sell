class ListingsController < ApplicationController
    before_action :authenticate_user!, except: [:index]
    before_action :listing_params, only: [:create]
    before_action :set_listing, only: [:show, :edit, :update, :destroy]

    #initialize all rows of the listings table with eager load to reduce (N+1 queries)
    def index
        @q = Listing.ransack(params[:q])
        @listings = @q.result.includes(picture_attachment: :blob).paginate(:page => params[:page], :per_page=>9)
    end

    #query listing table to check sold column, so only unsold items can be viewed
    #query user.id to ensure that payment button will only be displayed if
    #user viewing != user selling
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
                    seller_id: @listing.user_id,
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
    
    #instantiate a new listing row with all params (all required)
    #validation ensures the listing is valid before saving the row
    #then redirects to the listings new page
    #if any fields do not meet validation then error flash will show
    #with the new page being re-rendered

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

    #if update has all params and these pass validation then
    #the listing row will be updated, saved and redirected to the items
    #show page. Otherwise the errors will flash on the re-rendered edit page.
    def update
        if @listing.update(listing_params) && @listing.valid?
            @listing.save!
            redirect_to @listing
        else
            flash.now[:messages] = @listing.errors.full_messages
            render "edit"
        end
    end

    #if listing row exists, then listing row is dropped from table
    #then redirect to account page (only page you can delete from).
    def destroy
        if @listing.present?
          @listing.destroy!
        end
        redirect_to account_path, notice: "Listing was successfully deleted"
    end
    
private

    #permissions for listing table so only specified input fields can be passed
    #to the database.

    def listing_params
        params.require(:listing).permit(:brand, :style, :size, :price, :description, :picture)
    end

    #finds the listing id. Used as a helper for controller methods.
    
    def set_listing
        @listing = Listing.includes(:user).find(params[:id])
    end
end
