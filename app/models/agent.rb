class Agent < ActiveRecord::Base

	scope :free, -> { where("busy IS NULL") }

	def set_free
		busy = nil
		save
	end
end
