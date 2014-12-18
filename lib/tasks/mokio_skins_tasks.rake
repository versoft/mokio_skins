# desc "Explaining what the task does"
# task :mokio_skins do
#   # Task goes here
# end

namespace :mokio_skinss do
	task :build do
		Rake::Task['mokio_skins:install:migrations'].execute
	end
end
