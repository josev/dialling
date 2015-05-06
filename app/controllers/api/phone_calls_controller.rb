
class Api::PhoneCallsController < ApplicationController

	include Api::PhoneCallsHelper

	def call
		unless params[:phone_number].blank?
			response = process_call
			render json: response, status:response.code  and return
		end
		render nothing: true, status: 406
	end
end
