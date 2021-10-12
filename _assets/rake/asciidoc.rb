=begin "asciidoc.rb" v0.2.0| 2021/09/10 | by Tristano Ajmone | MIT License
================================================================================
Some custom Rake helper methods for automating common Asciidoctor operations
that we use across different documentation projects.
================================================================================
=end

$rouge_dir = "#{$repo_root}/_assets/rouge"

require 'asciidoctor'
require "#{$rouge_dir}/custom-rouge-adapter.rb"

def CreateAsciiDocHTMLTasksFromFolder(target_task, target_folder, dependencies)
  adoc_sources = FileList["#{target_folder}/*.asciidoc"].each do |adoc_fpath|
    doc_src = adoc_fpath.pathmap("%f")
    html_fpath = adoc_fpath.ext('.html')
    task target_task => html_fpath
    file html_fpath => adoc_fpath
    file html_fpath => dependencies
    file html_fpath do
      TaskHeader("Converting Document: #{adoc_fpath}")

      cd "#{$repo_root}/#{target_folder}"
      Asciidoctor.convert_file \
        "#{doc_src}",
        backend: :html5,
        safe: :unsafe,
        attributes: {
          'source-highlighter' => 'rouge',
          'rouge-style' => 'thankful_eyes',
          'docinfodir' => $rouge_dir,
          'docinfo' => 'shared-head'
        }
      cd $repo_root, verbose: false
    end
  end
end
