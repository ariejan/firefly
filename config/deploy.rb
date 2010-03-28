set :application, "firefly"
set :repository,  "git://github.com/ariejan/firefly.git"

set :scm, :git
set :user, 'root'
set :deploy_to, "/var/rails/#{application}"

set :rails_env, 'production'

role :web, "aj.gs"
role :app, "aj.gs"
role :db, "aj.gs", :primary => true

set :keep_releases, 3
after "deploy", "deploy:cleanup"
after "deploy:update", "deploy:database"
after "deploy:update", "deploy:configure"
after "deploy:update", "deploy:bundle"
after "deploy:update", "deploy:chown"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    run "#{try_sudo} /etc/init.d/varnish restart"
  end
  task :configure, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} cp #{shared_path}/config.ru #{release_path}/config.ru"
  end
  task :database, :roles => :db, :except => { :no_release => true } do
    run "#{try_sudo} ln -sf #{shared_path}/firefly_#{rails_env}.sqlite3 #{release_path}/firefly_#{rails_env}.sqlite3"
  end  
  task :bundle do
    run "#{try_sudo} rm -rf #{release_path}/.bundle"
    run "cd #{release_path} ; #{try_sudo} bundle install"
    run "#{try_sudo} chown -R www-data:www-data #{release_path}/.bundle"
  end
  task :chown do
    run "#{try_sudo} chown -RL www-data:www-data #{release_path}"
  end
end