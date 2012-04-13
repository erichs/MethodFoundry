# ##### Teach Bash new tricks here! #####

#  OpenStruct instances must minimally define these attributes:
#       description: string describing the action taken
#       match:       lambda returning boolean
#       strike:      lambda returning a bash-evaluable string
#
#  below, the 'match' and 'strike' lambdas use 1.9 'SLAMbda' syntax:
#
#  ->(c) { ... }
#
#  where 'c' is shorthand for 'command', passed in by MatchFactory
#
# <sidebar> This syntax is commonly referred to as 'stabby proc'. I can get
# behind the 'stabby' part of the moniker, but I take issue with 'proc',
# since they're really lambdas. If there's room for one more contender, it
# would please me if the community would adopt the term 'SLAMbda', it's one
# syllable shorter and more evocative. The 'S' could stand for 'stabby',
# 'sideways', or 'syntax sugar'.</sidebar>

# change directories
dir = OpenStruct.new
dir.description = 'a directory ending in slash'
dir.match = ->(c) { c =~ /^.*\/$/ }
dir.strike = ->(c) { "cd #{c} && ls" }

# clone git repo with git://
gitrepo = OpenStruct.new
gitrepo.description = 'Clone any full git repo URL.'
gitrepo.match = ->(c) { c =~ /^git(@|:\/\/).*\.git$/ }
gitrepo.strike = ->(c) { "git clone #{c}" }

# unzip archive URL
tarurl = OpenStruct.new
tarurl.description = 'Download and unzip URL'
tarurl.match = ->(c) { c =~ /^(?:ftp|https?):\/\/.+\.t(?:ar\.)?gz$/ }
tarurl.strike = ->(c) { "curl #{c} | tar xzv" }

# open any URL
url = OpenStruct.new
url.description = 'open URL in browser'
url.match = ->(c) { c =~ /^(https?):\/\/.+$/ }
url.strike = ->(c) { "open #{c}" }

# run cucumber feature
cuke = OpenStruct.new
cuke.description = 'run cucumber feature'
cuke.match = ->(c) { c =~ /^[a-z0-9_\-\/]+\.feature$/ }
cuke.strike = ->(c) { "cucumber #{c}" }

# install gem
gem = OpenStruct.new
gem.description = 'install gem'
gem.match = ->(c) { c =~ /^([A-Za-z0-9_\-\/]+)\.gem$/ && @gem_to_install = $1 }
gem.strike = ->(c) { "sudo gem install #{@gem_to_install}" }

# run rake task
# TODO: support Rake parameters[]
rake = OpenStruct.new
rake.description = 'run Rake task'
rake.match = ->(c) { require 'open3'
                     stdout, stderr, status = Open3.capture3('rake -T')
                     if status.success?
                                                    # strip trailing comments
                       tasks=stdout.split("\n").map { |str| str.split('#')[0] }
                       matching_tasks = tasks.find_all { |t| t =~ /#{c}/ }
                       return true unless matching_tasks.empty?
                     end
                   }
rake.strike = ->(c) { "rake #{c}" }
