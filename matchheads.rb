# ##### Teach Bash new tricks here! #####

#  OpenStruct instances must minimally define these attributes:
#       description:    string describing the action taken
#       match:          lambda returning boolean
#       strike:       lambda returning a bash-evaluable string

# change directories
dir = OpenStruct.new
dir.description = 'a directory ending in slash'
dir.match = ->(b) { b =~ /^.*\/$/ }
dir.strike = ->(b) { "cd #{b} && ls" }

# clone git repo with git://
gitrepo = OpenStruct.new
gitrepo.description = 'Clone any full git repo URL.'
gitrepo.match = ->(b) { b =~ /^git(@|:\/\/).*\.git$/ }
gitrepo.strike = ->(b) { "git clone #{b}" }

# unzip archive URL
tarurl = OpenStruct.new
tarurl.description = 'Download and unzip URL'
tarurl.match = ->(b) { b=~ /^(?:ftp|https?):\/\/.+\.t(?:ar\.)?gz$/ }
tarurl.strike = ->(b) { "curl #{b} | tar xzv" }

# open any URL
url = OpenStruct.new
url.description = 'open URL in browser'
url.match = ->(b) { b =~ /^(https?):\/\/.+$/ }
url.strike = ->(b) { "open #{b}" }

# run cucumber feature
cuke = OpenStruct.new
cuke.description = 'run cucumber feature'
cuke.match = ->(b) { b =~ /^[a-z0-9_\-\/]+\.feature$/ }
cuke.strike = ->(b) { "cucumber #{b}" }

# install gem
gem = OpenStruct.new
gem.description = 'install gem'
gem.match = ->(b) { if b =~ /^([A-Za-z0-9_\-\/]+)\.gem$/
                      @gem_to_install = $1
                    end
                  }
gem.strike = ->(b) { "sudo gem install #{@gem_to_install}" }

# run rake task
rake = OpenStruct.new
rake.description = 'run Rake task'
rake.match = ->(b) {
                  require 'open3'
                  stdout, stderr, status = Open3.capture3('rake -T')
                  if status.success?
                    tasks=stdout.split("\n").map { |str| str.split('#')[0] }
                    # TODO: support Rake parameters[]
                    matching_tasks = tasks.find_all { |t| t =~ /#{b}/ }
                    return true unless matching_tasks.empty?
                  end
                }
rake.strike = ->(b) { "rake #{b}" }
