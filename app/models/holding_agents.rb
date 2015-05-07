class HoldingAgents
	@@fifo = Array.new

	def self.add agent_id
		@@fifo.unshift agent_id
	end

	def self.pull
		@@fifo.pop
	end
end
