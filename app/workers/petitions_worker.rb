require 'net/http'
class PetitionsWorker
	include Sidekiq::Worker

	@@new_phones = 0
	@@machine_phones = 0
	@@busy_phones = 0
	@@unanswered_phones = 0
	@@uri = URI.parse('http://localhost:3000/api/phone_calls/call') # ?phone_number=#{phone_number}')

	def perform
		loop do
			agents_count = Agent.count
			avg_diff = (monthly_calltime_average - today_calltime_average).abs
			count_to_process = agents_count * calling_factor +
				( agents_count - 1 ) * hours_factor +
				agents_count * avg_diff
			make_petitions count_to_process.to_i
			sleep 1
		end
	end

	def make_petitions count
		count.times do
			if @@new_phones * 2 <= @@machine_phones + @@busy_phones + @@unanswered_phones
				phone = get_new_phone
			end
			phone = get_processed_phone if phone.nil?
			PetitionsWorker.delay.ask phone.number
		end
	end

	def self.ask phone_number
		params = { phone_number: phone_number }
		@@uri.query = URI.encode_www_form params
		response = Net::HTTP.get_response @@uri
=begin
		#url = URI.parse('http://localhost:3000/api/phone_calls/call?phone_number=#{phone_number}')
		ttp = Net::HTTP.new(url.host, url.port)
		request = Net::HTTP::Get.new(url.request_uri)
		response = http.request(request)
=end
		code = response.code
		process_response phone_number, code
	end

	def self.process_response phone_number, code
		if code == PhoneCallResponse::CONNECTED.code
			agent = HoldingAgents.pull
			if agent.present?
				PetitionsWorker.delay.start_call phone_number, agent.id
			end
			#TODO other scenarios

		end

	end

	def self.start_call phone_number, agent_id
		phone = PhoneNumber.find_by number: phone_number
		call = ActiveCall.create number: phone.number, agent: agent_id
		agent = Agent.find agent_id
		agent.update busy: phone_number
		phone.update last_status: PhoneCallResponse::CONNECTED.code
		call_duration_seconds = rand(today_calltime_average) + rand(monthly_calltime_average)
		sleep call_duration_seconds
		finish_call call.id, call_duration_seconds
	end

	def self.finish_call call_id, duration
		call = ActiveCall.find call_id
		call.update duration: duration
		agent = Agent.find call.agent
		agent.set_free
	end

	def get_new_phone
		phone = PhoneNumber.fresh.first
		return nil if phone.nil?
		phone.process
		@@new_phones+=1
		phone
	end

	def get_processed_phone
		phone = get_not_answered
		phone = get_not_processed if phone.nil?
		get_machine_answered if phone.nil?
	end

	def get_not_answered
		phone = PhoneNumber.busy.first
		return nil if(phone.nil?)
		phone.process
		phone
	end

	def get_not_processed
		phone = PhoneNumber.not_processed.first
		return nil if(phone.nil?)
		phone.process
		phone
	end


	def get_machine_answered
		phone = PhoneNumber.machine_answered.first
		return nil if(phone.nil?)
		phone.process
		phone
	end

	def calling_factor
		Rails.application.config.calling_factor
	end
	def hours_factor
		Rails.application.config.hours_factor
	end
	def monthly_calltime_average
		Rails.application.config.monthly_calltime_average
	end
	def today_calltime_average
		Rails.application.config.today_calltime_average
	end

end