class PhoneCallResponse
	include ApplicationHelper
	attr_accessor :name, :code
	STATUS = {
		connected:200,
		answer_machine:300,
		busy:400,
		unprocessed:500,
		not_answered:501
	}

	def initialize name, code
		@name = name
		@code = code
	end
	def self.length
		return STATUS.length
	end
	def self.by_index index
		key = STATUS.keys[index]
		value = STATUS[key]
		PhoneCallResponse.new key, value
	end
end