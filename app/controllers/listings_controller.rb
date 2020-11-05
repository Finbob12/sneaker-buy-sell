class ListingsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :listing_params, only: [:create]
    before_action :set_listing, only: [:show]

    def index
        @listings = Listing.all
    end

    def new 
        @listing = Listing.new
    end
    
    def create
        current_user.listings.create(listing_params) #this wont work until devise done
        redirect_to listings_path
    end

    def destroy
        @listing = Listing.find(params[:id])
        if @listing.present?
          @listing.destroy
        end
        redirect_to root_url
    end
    
private

    def listing_params
        params.require(:listing).permit(:brand, :style, :size, :price, :description)
    end

    def set_listing
        @listing = Listing.find(params[:id])
    end
end