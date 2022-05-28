=begin "asciidoc.rb" v0.3.1 | 2022/05/28 | by Tristano Ajmone | MIT License
================================================================================
Some custom Rake helper methods for automating common Asciidoctor operations
that we use across different documentation projects.
================================================================================
=end

require 'asciidoctor' # needed for Rouge!
require 'open3'

def AsciidoctorConvert(source_file, adoc_opts = "", dest_dir = nil)
  # ----------------------------------------------------------------------------
  TaskHeader("Converting to HTML: #{source_file}")
  src_dir = source_file.pathmap("%d")
  src_file = source_file.pathmap("%f")
  adoc_opts = adoc_opts.chomp + " --destination-dir #{$repo_root}/#{dest_dir}" unless !dest_dir
  adoc_opts = adoc_opts.chomp + " #{src_file}"
  cd "#{$repo_root}/#{src_dir}"
  begin
    stdout, stderr, status = Open3.capture3("asciidoctor #{adoc_opts}")
    puts stderr if status.success? # Even success is logged to STDERR!
    raise unless status.success?
  rescue
    rake_msg = our_msg = "Asciidoctor conversion failed: #{source_file}"
    out_file = src_file.ext('.html')
    if File.file?(out_file)
      our_msg = "Asciidoctor reported some problems during conversion.\n" \
        "The generated HTML file should not be considered safe to deploy."

      # Since we're invoking Asciidoctor with failure-level WARN, if the HTML
      # file was created we must set its modification time to 00:00:00 to trick
      # Rake into seeing it as an outdated target. (we're not 100% sure whether
      # it was re-created or it's the HTML from a previous run, but we're 100%
      # sure that it's outdated.)
      SetFileTimeToZero(out_file)
    end
    PrintTaskFailureMessage(our_msg, stderr)
    # Abort Rake execution with error description:
    raise rake_msg
  ensure
    cd $repo_root, verbose: false
  end
end

def CreateAsciiDocHTMLTasksFromFolder(target_task,
                                      target_folder,
                                      dependencies = nil,
                                      adoc_opts = "",
                                      dest_dir = nil)
  # ----------------------------------------------------------------------------
  # Give a 'target_task', a 'target_folder' and a list of 'dependencies', create
  # a file task to convert every '.asciidoc' file to HTML with 'dependencies' as
  # its prerequisites and 'adoc_opts' as Asciidoctor invocations options.
  # The optional 'dest_dir' parameter allows specifying the output folder.
  # ----------------------------------------------------------------------------
  adoc_sources = FileList["#{target_folder}/*.asciidoc"].each do |adoc_fpath|
    html_fpath = (dest_dir ? dest_dir + '/' + adoc_fpath.pathmap("%f") : adoc_fpath).ext('.html')
    task target_task => html_fpath
    file html_fpath => adoc_fpath
    file html_fpath => dependencies if dependencies
    file html_fpath do
      AsciidoctorConvert(adoc_fpath, adoc_opts, dest_dir)
    end
  end
end
