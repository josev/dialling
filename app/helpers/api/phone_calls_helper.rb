module Api::PhoneCallsHelper
	def process_call
		size = PhoneCallResponse.length
		random_index = rand(size)
		PhoneCallResponse.by_index random_index
	end
end
