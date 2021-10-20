=begin "alan.rb" v0.4.0 | 2021/10/20 | by Tristano Ajmone | MIT License
================================================================================
Some custom Rake helper methods for automating common Alan SDK operations that
we use across different Alan projects.
Require ALAN SDK >= Beta8 and UFT-8 encoded sources and solutions.
================================================================================
=end

require 'open3'

def CreateTranscript(storyfile, solution)
  # ----------------------------------------------------------------------------
  # Generate a transcript with the same base filename as the solution:
  #
  #   "<filename>.a3s" -> "<filename>.a3t"
  #
  # This method only supports UTF-8 solutions, with or without BOM. If a BOM is
  # present it will be stripped off before feeding the solution to ARun, so it
  # doesn't leak into the final transcript (as it would if redirecting the .a3s
  # to ARun via 'arun < solution.a3s > transcript.a3t')
  # ----------------------------------------------------------------------------
  TaskHeader("Generating Transcript: #{solution.ext('.a3t')}")

  target_folder = storyfile.pathmap("%d")
  a3s = solution.pathmap("%f")
  a3t = a3s.ext('.a3t')
  a3c = storyfile.pathmap("%f")

  cd "#{$repo_root}/#{target_folder}"
  sol_file = File.open(a3s, mode: "rt", encoding: "BOM|UTF-8")
  IO.popen("arun -r -u #{a3c} > #{a3t}", "r+") do |transcript|
    transcript.puts sol_file.read
  end
  cd $repo_root, verbose: false
end


def CreateTranscriptingTasksFromFolder(target_task, target_folder, dependencies)
  # -----------------------------------------------------------------------
  # Process the target folder adding to the target task all the storyfiles
  # and transcripts as dependencies, and create all the required file tasks
  # dependencies. Can handle multiple adventures in a same folder, in which
  # case solutions will be associate to each adventure according to its
  # base filename: "<advname>*.sol"
  # -----------------------------------------------------------------------
  alan_sources = FileList["#{target_folder}/*.alan"]
  alan_sources.each do |alan_src|
    storyfile = alan_src.ext('.a3c')
    task target_task => storyfile
    file storyfile => alan_src
    file storyfile => dependencies
    if alan_sources.count() == 1
      # Single adventure: all solutions apply to it.
      solutions = FileList["#{target_folder}/*.a3s"]
    else
      # There are multiple adventures in a same folder!
      # Associate solutions using "<advname>*.sol" pattern.
      basename = storyfile.pathmap("%n")
      solutions = FileList["#{target_folder}/#{basename}*.a3s"]
    end
    solutions.each do |solution|
      transcript = solution.ext('.a3t')
      task target_task => transcript
      file transcript => [solution, storyfile] do |transcript|
        CreateTranscript(storyfile, solution)
      end
    end
  end
end


## Rake Rules
#############

## Compile ALAN Adventures
##########################

# To allow this to work with different repositories, the path for the '-include'
# option (if any) is stored in the global variable '$alan_include', which each
# project can optionally define in its main Rakefile.
#
# '$alan_include' can contain an absolute or relative path.
#
# This is a temporary solution with limited use coverage, e.g. it won't work
# in projects using different libraries or requiring multiple include paths
# (e.g. for other extensions). Until a better solution is found, complex repos
# will have to use 'Import' statements with relative paths to work around this
# limitation, e.g.
#
#   Import '../path/somefile.i'.
#
# Instead of:
#
#   Import 'somefile.i'.

rule ".a3c" => ".alan" do |t|
  adv_src = t.source.pathmap("%f")
  adv_dir = t.source.pathmap("%d")
  inc_opt = " -include #{$alan_include}" unless !$alan_include

  TaskHeader("Compiling: #{t.source}")

  cd "#{$repo_root}/#{adv_dir}"
  begin
    alan_cmd = "alan#{inc_opt} #{adv_src}"
    puts alan_cmd
    stdout, stderr, status = Open3.capture3(alan_cmd)
    raise unless status.success?
  rescue
    err_head = "\n*** ADVENTURE COMPILATION FAILED! "
    puts err_head << '*' * (73 - err_head.length)
    puts stdout # ALAN reports errors on stdout, not on stderr!
    puts '*' * 72
    # Abort Rake execution with error description:
    raise "ALAN compilation failed: #{t.source}"
  ensure
    cd $repo_root, verbose: false
  end
end
