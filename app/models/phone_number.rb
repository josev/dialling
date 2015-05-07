class PhoneNumber < ActiveRecord::Base
	default_scope { order( number: :asc ) }
	scope :available, -> { where(in_process: false) }
	scope :fresh, -> { available.where("last_status IS NULL") }
	scope :machine_answered, -> {
		available.where(
			"last_status=? AND tryouts<? AND last_taken>=?"
			PhoneCallResponse::code_by_name :answer_machine,
			3,
			Time.now - 2.minute
			)
	}

	scope :busy, -> {
		available.where(
			"last_status=? AND tryouts<? AND last_taken>=?"
			PhoneCallResponse::code_by_name :busy,
			3,
			Time.now - 1.minute
			)
	}
	scope :not_processed, -> {
		available.where(
			"last_status=? AND tryouts<? AND last_taken>=?"
			PhoneCallResponse::code_by_name :not_processed,
			2,
			Time.now - 3.minute
			)
	}

	def process
		in_process=true
		tryouts+=1
		save
	end
end
