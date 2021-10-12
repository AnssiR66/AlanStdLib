=begin "globals.rb" v0.2.0 | 2021/09/10 | by Tristano Ajmone | MIT License
================================================================================
Some custom Rake helpers required by our custom Ruby modules and which are used
in most of our Rakefiles.
================================================================================
=end

$repo_root = pwd

# Define OS-specific name of Null device, for redirection
case RUBY_PLATFORM
when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
  $devnull = "NUL"
else
  $devnull = "/dev/null"
end

def TaskHeader(text)
  hstr = "## #{text}"
  puts "\n#{hstr}"
  puts '#' * hstr.length
end
