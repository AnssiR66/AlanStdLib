# Rouge Adapter for ALAN                v1.0.0 | 2021/07/30 | by Tristano Ajmone
# ==============================================================================
# Created with the kind support of Dan Allen (@mojavelinux) from the Asciidoctor
# Project, who helped me out with with this when I was stuck. Thanks Dan!
#
#   https://github.com/asciidoctor/asciidoctor/issues/4080
# ==============================================================================

class CustomRougeAdapter < (Asciidoctor::SyntaxHighlighter.for 'rouge')
  register_for 'rouge'

  # Defer loading Rouge until the `load_library` method is called:
  def load_library
    require 'rouge'
    # The "alan3.rb" lexer must be in same folder as this script!
    herepath=File.expand_path(File.dirname(__FILE__))
    require "#{herepath}/alan3.rb"
    :loaded
  end

  def format node, lang, opts
    opts[:transform] = proc do |pre, code|
      code['class'] = %(language-#{lang}) if lang
      # Add to the generated <pre> tag  the`lang=` attribute,
      # in order to control CSS styling of code blocks:
      #   <pre class="rouge highlight" lang="alan">
      pre['lang'] = %(#{lang}) if lang
    end
    super
  end

end
