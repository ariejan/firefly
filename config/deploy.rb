set :application, "firefly"
set :repository,  "git://github.com/ariejan/firefly.git"

set :scm, :git
set :user, 'root'
set :deploy_to, "/var/rails/#{application}"

role :web, "aj.gs"
role :app, "aj.gs"
role :db, "aj.gs", :primary => true

set :keep_releases, 3
after "deploy", "deploy:cleanup"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end