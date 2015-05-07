class HoldingClients
	@@fifo = Array.new

	def self.add phone_number
		@@fifo.unshift phone_number
	end

	def self.add_top phone_number
		@@fifo.push phone_number
	end

	def self.pull
		@@fifo.pop
	end
end
