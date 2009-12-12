# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

ensure_in_path 'lib'
require 'girffi'

task :default => 'test:run'

PROJ.name = 'gir-ffi'
PROJ.authors = 'Matijs van Zuijlen'
PROJ.email = 'matijs@matijs.net'
PROJ.url = 'http://www.github.com/mvz/ruby-gir-ffi'
PROJ.version = GirFFI::VERSION
PROJ.readme_file = 'README.rdoc'

PROJ.gem.dependencies << ['ffi', '~> 0.5.0']
PROJ.gem.development_dependencies << ['shoulda', '~> 2.10.2']

PROJ.rcov.opts << '--exclude /var/lib/gems'
# EOF
