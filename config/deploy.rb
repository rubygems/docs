require 'vlad/subversion'

set :repository,  'svn+ssh://rubyforge.org/var/svn/rubygems/docs.rubygems.org'
set :application, 'docs.rubygems.org'
set :deploy_to,   '/data/www/docs.rubygems.org'
set :domain,      'docs.rubygems.org'
set :rails_env,   'production'

namespace :vlad do
  remote_task :start_app, :roles => :app do
    run "sudo pkill -TERM -u www -f #{domain}/current/public/dispatch.fcgi || echo not running, start apache"
  end

  remote_task :stop_app, :roles => :app # nothing to do

  remote_task :setup_app, :roles => :app do
  end

  remote_task :update, :roles => :app do
    run "sudo chown $USER:www #{shared_path}/log/#{rails_env}.log"
    run "sudo chmod g+w #{shared_path}/log/#{rails_env}.log"
  end

  remote_task :mark_deployment do
    run "cd #{deploy_to}/scm/; ruby vendor/plugins/newrelic_rpm/bin/newrelic_cmd deployments -a docs.rubygems.org -e production -r `svnversion #{deploy_to}/scm`"
  end

end

desc 'Deploy the website to the selected site'
task :deploy => %w[vlad:update vlad:mark_deployment vlad:start_app]

