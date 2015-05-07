namespace :db do
	desc "Setup Agents"
	task :seed_agents => :environment do
		Agent.create
	end
	desc "Setup Phone Numbers"
	task :seed_phone_numbers => :environment do
		first_number = 1111111111
		last_number  = 9999999999
		ActiveRecord::Base.transaction do
			first_number.upto(last_number) do |phone_number|
				PhoneNumber.create number:phone_number, in_process:false, tryouts:0
			end
		end
	end
	task :seed => [:seed_agents, :seed_phone_numbers]
end