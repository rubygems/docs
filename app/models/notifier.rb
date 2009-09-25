class Notifier < ActionMailer::Base

	def account_approval(author, sent_on = Time.now)
		# Email header info
		@recipients = "#{author.name} <#{author.email}>"
		@from       = CONFIG['email_from']
		@subject    = "Your login request has been approved"
		@sent_on    = sent_on

		# Email body substitutions
		@body["name"] = author.name
		@body["login"] = author.login
	end

end

