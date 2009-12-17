require 'capistrano/recipes/deploy/scm/base'

module Capistrano
  module Deploy
    module SCM
      class Subversion < Base
        # Returns working subversion repository path
        # Defaults to trunk
        # If variable :tag or :branch are set, path is adjusted
        # Repository path should refer to root of standard svn layout
        def repository
          if variable(:svn_explicit_path)
            variable(:repository)
          elsif variable(:tag)
            "#{variable(:repository)}/tags/#{variable(:tag)}"
          elsif variable(:branch)
            "#{variable(:repository)}/branches/#{variable(:branch)}"
          else
            "#{variable(:repository)}/trunk"
          end
        end
      end
    end
  end
end
