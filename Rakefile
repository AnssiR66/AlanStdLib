=begin "Rakefile" v0.3.1 | 2022/05/30 | by Tristano Ajmone
================================================================================
This is the Rakefile for the Alan-StdLib repository.

It handles the whole toolchain, except for building Dia SVG diagrams because we
couldn't find a good cross platform solution since we require a specific version
of Dia (older) which is only available for Windows.
================================================================================
=end

# Custom helpers shared among ALAN repos ...

require './_assets/rake/globals.rb'
require './_assets/rake/alan.rb'
require './_assets/rake/asciidoc.rb'

# ==============================================================================
# --------------------{  P R O J E C T   S E T T I N G S  }---------------------
# ==============================================================================

# Absolute path to StdLib for ALAN '-include' option:
$alan_include = "#{$repo_root}/lib_source/StdLib"

STDLIB_SOURCES = FileList['lib_source/StdLib/*.i']

$rouge_dir = "#{$repo_root}/_assets/rouge"
require "#{$rouge_dir}/custom-rouge-adapter.rb"

ADOC_OPTS = <<~HEREDOC
  --failure-level WARN \
  --verbose \
  --timings \
  --safe-mode unsafe \
  --require #{$rouge_dir}/custom-rouge-adapter.rb \
  -a source-highlighter=rouge \
  -a rouge-style=thankful_eyes \
  -a docinfodir=#{$rouge_dir} \
  -a docinfo@=shared-head \
  -a data-uri
HEREDOC

# ==============================================================================
# -------------------------------{  T A S K S  }--------------------------------
# ==============================================================================

task :default => [:tests, :library, :extras, :docs]


## Clean & Clobber
##################
require 'rake/clean'

CLEAN.include('**/*.a3t-adoc')

CLOBBER.include('**/*.a3c')
CLOBBER.include('**/*.a3t')
CLOBBER.include('**/*.html').exclude('_assets/**/*.html', '_assets_src/**/*.html')
CLOBBER.include('lib_distro/docs/**/*.alan')
CLOBBER.include('lib_distro/extras/*.alan')
CLOBBER.include('lib_distro/StdLib/*.*')


## Test Suite
#############

desc "StdLib test suite"
task :tests

TESTS_DEPS = STDLIB_SOURCES + FileList['lib_tests/*.i']

CreateTranscriptingTasksFromFolder(:tests,'lib_tests/clothing', TESTS_DEPS)
CreateTranscriptingTasksFromFolder(:tests,'lib_tests/house', TESTS_DEPS)
CreateTranscriptingTasksFromFolder(:tests,'lib_tests/integrity', TESTS_DEPS)
CreateTranscriptingTasksFromFolder(:tests,'lib_tests/liquids', TESTS_DEPS)
CreateTranscriptingTasksFromFolder(:tests,'lib_tests/misc', TESTS_DEPS)


## Sanitized Library
####################

desc "Sanitize StdLib to distro folder"
task :library
CreateSanitizeAndDeployAlanSourcesTasksFromFolder(:library, 'lib_source/StdLib', 'lib_distro/StdLib')


## Extras Folder
################

desc "Sanitize 'extras' folder to distro"
task :extras
FileList['lib_source/extras/*.alan'].each do |alan_src|
  alan_out = 'lib_distro/extras/' + alan_src.pathmap("%f")
  task :extras => alan_out
  file alan_out => alan_src do
    SanitizeAndDeployAlanSources(alan_src, alan_out)
  end
end


## Documentation
################

desc "Documentation and examples"
task :docs => [:lib_docs, :tutorials, :manual]


## Library Info Docs
####################

# Build generic library documents (CHANGELOG, etc.):
# Convert all `.asciidoc` files from "lib_source/" to HTML into "lib_distro/".

task :lib_docs => CreateAsciiDocHTMLTasksFromFolder(:lib_docs, 'lib_source', nil, ADOC_OPTS, 'lib_distro')


## StdLib Manual
################

task :manual => [:man_doc, :man_examples]

task :man_doc
MAN_DEPS = FileList[
  'lib_source/docs/LibManual/*.adoc',
  'lib_source/_shared*.adoc'
] + FileList['lib_source/docs/LibManual/*.a3s'].ext('.a3t-adoc') + STDLIB_SOURCES

CreateADocTranscriptingTasksFromFolder(:man_doc,'lib_source/docs/LibManual', STDLIB_SOURCES)
CreateAsciiDocHTMLTasksFromFolder(:man_doc,'lib_source/docs/LibManual', MAN_DEPS, ADOC_OPTS,'lib_distro/docs/LibManual')

task :man_examples
CreateSanitizeAndDeployAlanSourcesTasksFromFolder(:man_examples, 'lib_source/docs/LibManual', 'lib_distro/docs/LibManual')


## Tutorials
############

task :tutorials => [:tut_doc, :tut_examples]

task :tut_doc
TUTORIALS_DOCS_DEPS = FileList[
    'lib_source/*.adoc'
] + FileList['lib_source/docs/ClothingGuide/*.a3s'].ext('.a3t-adoc')

CreateADocTranscriptingTasksFromFolder(:tut_doc,'lib_source/docs/ClothingGuide', STDLIB_SOURCES)
CreateAsciiDocHTMLTasksFromFolder(:tut_doc,'lib_source/docs/ClothingGuide', TUTORIALS_DOCS_DEPS, ADOC_OPTS,'lib_distro/docs/ClothingGuide')

task :tut_examples
CreateSanitizeAndDeployAlanSourcesTasksFromFolder(:tut_examples, 'lib_source/docs/ClothingGuide', 'lib_distro/docs/ClothingGuide')
