=begin "Rakefile" v0.2.2 | 2022/05/07 | by Tristano Ajmone
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
$alan_include = "#{$repo_root}/StdLib"

STDLIB_SOURCES = FileList['StdLib/*.i']

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
# -------------------------------{  R U L E S  }--------------------------------
# ==============================================================================

# Simple rule to copy HTML files from "extras_src/" to "extras/":

rule '.html' => [proc { |tn| tn.sub(/^extras\//, 'extras_src/') } ] do |t|
  TaskHeader("Copying: #{t.name}")
  cp(t.source, t.name, verbose: true)
end

# ==============================================================================
# -------------------------------{  T A S K S  }--------------------------------
# ==============================================================================

task :default => [:tests, :docs]


## Clean & Clobber
##################
require 'rake/clean'

CLEAN.include('**/*.a3t-adoc')
CLEAN.include('/extras_src/**/*.html')

CLOBBER.include('**/*.a3c')
CLOBBER.include('**/*.a3t')
CLOBBER.include('**/*.html').exclude('_assets/**/*.html', '_assets_src/**/*.html')
CLOBBER.include('extras/manual/*.alan')
CLOBBER.include('extras/tutorials/*.alan')


## Test Suite
#############

desc "StdLib test suite"
task :tests

TESTS_DEPS = STDLIB_SOURCES + FileList['tests/*.i']

CreateTranscriptingTasksFromFolder(:tests,'tests/clothing', TESTS_DEPS)
CreateTranscriptingTasksFromFolder(:tests,'tests/house', TESTS_DEPS)
CreateTranscriptingTasksFromFolder(:tests,'tests/integrity', TESTS_DEPS)
CreateTranscriptingTasksFromFolder(:tests,'tests/liquids', TESTS_DEPS)
CreateTranscriptingTasksFromFolder(:tests,'tests/misc', TESTS_DEPS)

## Documentation
################

desc "Documentation and examples"
task :docs => [:lib_docs, :tutorials, :manual]


## Library Info Docs
####################

# Library documents like 'CHANGELOG.html' which are built from AsciiDoc sources.

task :lib_docs => CreateAsciiDocHTMLTasksFromFolder(:lib_docs,'StdLib', nil, ADOC_OPTS)


## StdLib Manual
################

task :manual => [:man_doc, :man_examples]

task :man_doc
MAN_DEPS = FileList[
  'extras_src/manual/*.adoc',
  'extras_src/*.adoc'
] + FileList['extras_src/manual/*.a3s'].ext('.a3t-adoc') + STDLIB_SOURCES

CreateADocTranscriptingTasksFromFolder(:man_doc,'extras_src/manual', STDLIB_SOURCES)
CreateAsciiDocHTMLTasksFromFolder(:man_doc,'extras_src/manual', MAN_DEPS, ADOC_OPTS)

task :man_doc => 'extras/manual/StdLibMan.html'
file 'extras/manual/StdLibMan.html' => 'extras_src/manual/StdLibMan.html'

task :man_examples
CreateSanitizeAndDeployAlanSourcesTasksFromFolder(:man_examples, 'extras_src/manual', 'extras/manual')

## Tutorials
############

task :tutorials => [:tut_doc, :tut_examples]

task :tut_doc
TUTORIALS_DOCS_DEPS = FileList[
    'extras_src/*.adoc'
] + FileList['extras_src/tutorials/*.a3s'].ext('.a3t-adoc')

CreateADocTranscriptingTasksFromFolder(:tut_doc,'extras_src/tutorials', STDLIB_SOURCES)
CreateAsciiDocHTMLTasksFromFolder(:tut_doc,'extras_src/tutorials', TUTORIALS_DOCS_DEPS, ADOC_OPTS)

task :tut_doc => 'extras/tutorials/Clothing_Guide.html'
file 'extras/tutorials/Clothing_Guide.html' => 'extras_src/tutorials/Clothing_Guide.html'

task :tut_examples
CreateSanitizeAndDeployAlanSourcesTasksFromFolder(:tut_examples, 'extras_src/tutorials', 'extras/tutorials')
