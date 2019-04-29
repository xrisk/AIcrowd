class Submission::Cell < Template::Cell
	include LocalTimeHelper

	def entry
		model
	end

	def enable_links_in_raw_text(text)
		if text.nil?
			return
		end
		sanitize(text.gsub(/(https?:\/\/[\S]+)/, "<a href='\\1'>\\1</a>"))
	end

	def formatted_value(value)
		if value == nil
			return "-"
		else
			return value
		end
	end

	def grade_class
		# byebug
		if entry.grading_status_cd == "graded"
			return "badge-success"
		elsif entry.grading_status_cd == "initiated"
			return "badge-gold"			
		elsif entry.grading_status_cd == "submitted"
			return "badge-gold"
		elsif entry.grading_status_cd == "ready"
			return "badge-silver"
		else
			return "badge-warning"
		end
	end

	def challenge
		@challenge ||= model.challenge
	end

	def participant
		@participant ||= entry.participant
	end
end
