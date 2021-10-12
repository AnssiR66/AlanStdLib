=begin "Rakefile" v0.0.1 | 2021/10/12 | by Tristano Ajmone
================================================================================
This is an initial Rakefile draft for Alan-StdLib.

Currently only covers the test-suite.
================================================================================
=end


# Custom helpers shared among ALAN repos ...

require './_assets/rake/globals.rb'
require './_assets/rake/alan.rb'
# require './_assets/rake/asciidoc.rb'


## Tasks
########

task :default => :tests


## Clean & Clobber
##################
require 'rake/clean'
CLOBBER.include('**/*.a3c')
CLOBBER.include('**/*.a3t')
CLOBBER.include('**/*.html').exclude('**/docinfo.html')


## Test Suite
#############

STDLIB_SOURCES = FileList['StdLib/*.i']
TESTS_DEPS = FileList['StdLib/*.i','tests/*.i']

desc "StdLib test suite"
task :tests
CreateTranscriptingTasksFromFolder(:tests,'tests/clothing', TESTS_DEPS)
CreateTranscriptingTasksFromFolder(:tests,'tests/house', TESTS_DEPS)
CreateTranscriptingTasksFromFolder(:tests,'tests/integrity', TESTS_DEPS)
CreateTranscriptingTasksFromFolder(:tests,'tests/liquids', TESTS_DEPS)
CreateTranscriptingTasksFromFolder(:tests,'tests/misc', TESTS_DEPS)
