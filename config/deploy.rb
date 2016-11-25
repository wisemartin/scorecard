require "bundler/capistrano"

load 'deploy/assets'

ENV['RAILS_ENV'] ||= 'production'
set :rails_env, ENV['RAILS_ENV']

set :application, "scorecard"
#set :repository,  "set your repository location here"
set :use_sudo, false
set :scm,     :perforce

if RUBY_PLATFORM.match(/mingw/)
  ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa-admin")]
  ssh_options[:forward_agent] = true
end

env_setup =
  case rails_env.to_s
  when 'production'
    { server: 'icdupquaxapp01.pearsontc.com', god_port: 17168,
      client: 'hosting_scorecard',
      user:   'hosting',        password:'foo'
    }
  end

# use safe assets rather than cap's assets_prefix so that the latter is retained
# this needs to match the relative_url_root i.e. /safe
set :user,      env_setup[:user]
set :password,  env_setup[:password]

set :p4client, env_setup[:client]
set :p4port,   'perforce.ic.ncs.com:1424'
set :p4user,   'p4adm'
set :p4passwd, 'Fan8WL'

# Add extra options to Perforce sync command.
# This setting defaults to the value "-f" which forces resynchronization.
set :p4sync_flags, '-f'

role :web, env_setup[:server]
role :app, env_setup[:server]
role :db,  env_setup[:server], :primary => true

set :god_port, env_setup[:god_port]

# additional settings
set :deploy_to, "/data/app/#{application}/#{rails_env}"
set :bundle_dir, "/data/app/#{application}/bundle"

# Set the revision field to deploy a specific changelist (maybe works for labels?)
set :revision, (ENV['CL'] || ENV['REVISION']).to_s

ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa-admin")]

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end


def god_command(command)
  run "god -p #{god_port} #{command} #{application}"
end

def tail_log(logfile)
  trap("INT") { puts 'Interrupted'; exit 0; }
  run "tail -f #{logfile}" do |channel, stream, data|
    puts  # for an extra line break before the host name
    puts "#{channel[:host]}: #{data}"
    break if stream == :err
  end
end

namespace :deploy do
  desc "Restart the app server"
  task :restart, :roles => :app do
    god_command("restart")
  end

  desc "Start the app server"
  task :start, :roles => :app do
    god_command("start")
  end

  desc "Status the app server"
  task :status, :roles => :app do
    god_command("status")
  end

  desc "Stop the app server"
  task :stop, :roles => :app do
    god_command("stop")
  end

  desc "Stop then start app server"
  task :stop_start, :roles => :app do
    stop
    sleep 10
    start # in case monitoring does not
  end

  #namespace :assets do
  #  desc "symlink the safe assets prefix"
  #  task :safe_symlink, :roles => :app do
  #    if safe_assets
  #      run "rm -fr #{latest_release}/public/#{safe_assets} && mkdir -p #{latest_release}/public/#{safe_assets} && \
  #        ln -s #{shared_path}/assets #{latest_release}/public/#{safe_assets}/assets"
  #    end
  #  end
  #end

  namespace :tail do

    desc "tail unicorn_out log files"
    task :unicorn_out, :roles => :app do
      tail_log("#{deploy_to}/current/log/unicorn_out.log")
    end

    desc "tail unicorn_err log files"
    task :unicorn_err, :roles => :app do
      tail_log("#{deploy_to}/current/log/unicorn_err.log")
    end

    desc "tail production log files"
    task :production, :roles => :app do
      tail_log("#{deploy_to}/current/log/production.log")
    end

    desc "tail user_test log files"
    task :user_test, :roles => :app do
      tail_log("#{deploy_to}/current/log/user_test.log")
    end

  end
end

after "deploy", "deploy:cleanup", "deploy:stop_start"
