# "sanitize_a3log.sed"                  v0.0.2 | 2019/04/09 | by Tristano Ajmone
# ******************************************************************************
# *                                                                            *
# *                         Sanitize Alan Transcripts                          *
# *                                                                            *
# ******************************************************************************
# This sed script will reformat a verbatim Alan transcript into a well-formed
# AsciiDoc example block, which can then be included into a document.
# ------------------------------------------------------------------------------
# exclude from processing player input lines with region tags:
/^>\s*;\s*(tag|end)::/ !{
	# ===================
	# Chars Substitutions
	# ===================
	s/\*/{asterisk}/g     #   *   ->   {asterisk}
	s/\\/{backslash}/g    #   \   ->   {backslash}
	s/\x60/{backtick}/g   #   `   ->   {backtick}
	s/\^/{caret}/g        #   ^   ->   {caret}
	s/\+/{plus}/g         #   +   ->   {plus}
	s/~/{tilde}/g         #   ~   ->   {tilde}
	s/\[/{startsb}/g      #   [   ->   {startsb}
	s/]/{endsb}/g         #   ]   ->   {endsb}
	s/\_/\&lowbar;/g      #   _   ->   &lowbar;
	s/#/\&num;/g          #   #   ->   &num;
	# ==========================
	# Process player input lines
	# ==========================
	/^>/ {
		# ignore empty input lines:
		/^>\s*$/ !{
			# ignore input with only comments:
			/^>\s*;/ !{
				# ----------------------
				# Italicize Player Input
				# ----------------------
				# Unconstrained Italics
				s/^(>\s+)([^[:alpha:][:digit:]\s][^;]*?|[^;]*?[^[:alpha:][:digit:]\s])(\s*?)( ;.*)?$/\1__\2__\3\4/
				# Constrained Italics
				s/^(> *?)(\w[^;]*?\w)(\s*)(;.*)?$/\1_\2_\3\4/
			}
			# ---------------------
			# Player Input Comments
			# ---------------------
			s/(>[^;]+)(;.*)$/\1[comment]#\2#/
		}
		# -----------------
		# fix '>' to '&gt;'
		# -----------------
		s/^>/\&gt;/
	}
	# =========================
	# Preserve hard line breaks
	# =========================
	# ignore empty lines:
	/^$/ !{
		s/$/ +/
	}
}
# ====================
# AsciiDoc Region Tags
# ====================
# Convert to AsciiDoc commented line, so it won't be shown in document:
s/^>\s*;\s*((tag|end)::.*)$/\/\/ \1/
