require 'mina/rails'
require 'mina/git'
 require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
# require 'mina/rvm'    # for rvm support. (https://rvm.io)
require 'mina/whenever'
require 'mina/puma'
require 'mina/bundler'



# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)
set :rails_env, 'production'
set :application_name, 'example'
set :domain, '18.222.197.62'
set :use_sudo, true
set :deploy_to, '/var/www/example'
set :repository, 'https://github.com/KhrystynaInzhuvatova/example.git'
set :branch, 'master'
#set :ssh_options, '-A'
# Optional settings:
set :user, 'ubuntu'           # Username in the server to SSH to.
#set :port, '30000'           # SSH port number.
#set :forward_agent, true     # SSH forward_agent.
#set :term, :system
#set :execution_mode, :system

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
set :shared_dirs, fetch(:shared_dirs, []).push('public/assets')
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')
set :shared_paths, ['config/database.yml', 'log']
#set :shared_dirs, fetch(:shared_dirs, []).push('log')
set :shared_files, fetch(:shared_files, []).push(
  'config/secrets.yml',
  'db/production.sqlite3'
)

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
   invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use', 'ruby-1.9.3-p125@default'
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task setup: :remote_environment do
  deploy_to   = fetch(:deploy_to)
  shared_path = fetch(:shared_path)
  command %[sudo mkdir -p "#{fetch(:deploy_to)}/releases"]
  command %[sudo mkdir -p "#{fetch(:deploy_to)}/current"]
  command %[sudo mkdir "#{fetch(:deploy_to)}/shared/vendor/bundle"]
  command %[sudo mkdir "#{fetch(:deploy_to)}/shared/log"]
  command %[sudo mkdir "#{fetch(:deploy_to)}/shared/tmp/cache"]
  command %[sudo mkdir "#{fetch(:deploy_to)}/shared/db"]
  command %[sudo mkdir "#{fetch(:deploy_to)}/shared/config"]
  command %[sudo mkdir "#{fetch(:deploy_to)}/shared/public"]
  command %[sudo mkdir -p "#{fetch(:deploy_to)}/shared/public/assets"]
  command %[ sudo touch "#{fetch(:shared_path)}/config/database.yml"]
  command %[sudo touch "#{fetch(:shared_path)}/config/secrets.yml"]
  command %[sudo touch "#{fetch(:shared_path)}/config/puma.rb"]
  comment "Be sure to edit '#{fetch(:shared_path)}/config/database.yml', 'secrets.yml' and puma.rb."
  command %( sudo mkdir -p "#{fetch(:shared_path)}/tmp/sockets")
  command %(sudo chmod g+rx,u+rwx "#{fetch(:shared_path)}/tmp/sockets")
  command %(sudo mkdir -p "#{fetch(:shared_path)}/tmp/pids")
  command %(sudo chmod g+rx,u+rwx "#{fetch(:shared_path)}/tmp/pids")


  # command %{rbenv install 2.3.0 --skip-existing}
end

desc "Deploys the current version to the server."
task deploy: :remote_environment do

  deploy do
    comment "Deploying #{fetch(:application_name)} to #{fetch(:domain)}:#{fetch(:deploy_to)}"
    command 'pwd'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    #invoke :'rbenv:load'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    command %{#{fetch(:rails)} db:seed}
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      queue "sudo mkdir -p #{deploy}/#{current_path}/tmp/"
      queue "sudo touch #{deploy}/#{current_path}/tmp/restart.txt"
      #in_path(fetch(:current_path)) do
      #  command %(mkdir -p tmp/)
      #  command %(touch tmp/restart.txt)
      #end
      invoke :'puma:phased_restart'
    end
    #invoke :'deploy:cleanup'
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
