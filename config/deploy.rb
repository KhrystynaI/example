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

set :shared_dirs, fetch(:shared_dirs, []).push('log')
set :shared_files, fetch(:shared_files, []).push(
'config/secrets.yml',
'db/production.sqlite3'
)
task :remote_environment do
 invoke :'rbenv:load'
end

task :setup do
  command %[touch "#{fetch(:shared_path)}/config/database.yml"]
  command %[touch "#{fetch(:shared_path)}/config/secrets.yml"]
  command %[touch "#{fetch(:shared_path)}/config/puma.rb"]
  comment "Be sure to edit '#{fetch(:shared_path)}/config/database.yml', 'secrets.yml' and puma.rb."
end

task :deploy do
deploy do
  comment "Deploying #{fetch(:application_name)} to #{fetch(:domain)}:#{fetch(:deploy_to)}"
  invoke :'git:clone'
  invoke :'deploy:link_shared_paths'
  #invoke :'rvm:load_env_vars'
  invoke :'bundle:install'
  invoke :'rails:db_migrate'
  command %{#{fetch(:rails)} db:seed}
  invoke :'rails:assets_precompile'
  invoke :'deploy:cleanup'

  on :launch do
    invoke :'puma:phased_restart'
  end
end
end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
