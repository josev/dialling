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
	CONNECTED = PhoneCallResponse.by_index 0
	ANSWER_MACHINE = PhoneCallResponse.by_index 1
	BUSY = PhoneCallResponse.by_index 2
	UNPROCESSED = PhoneCallResponse.by_index 3
	NOT_ANSWERED = PhoneCallResponse.by_index 4

	def initialize name, code
		@name = name
		@code = code
	end
	def self.length
		return STATUS.length
	end
	def self.code_by_name name
		STATUS[name.to_sym]
	end
	def self.by_index index
		key = STATUS.keys[index]
		value = STATUS[key]
		PhoneCallResponse.new key, value
	end
end