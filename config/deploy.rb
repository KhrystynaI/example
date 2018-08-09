require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
#require 'mina/rvm'    # for rvm support. (https://rvm.io)
require 'mina/whenever'

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :application_name, 'example'
set :domain, '18.222.197.62'
set :deploy_to, '/ubuntu/example'
set :repository, 'https://github.com/KhrystynaInzhuvatova/example.git'
set :branch, 'master'

# Optional settings:
set :user, 'ubuntu'          # Username in the server to SSH to.
#   set :port, '30000'           # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
# set :shared_dirs, fetch(:shared_dirs, []).push('public/assets')
# set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')
set :shared_dirs, fetch(:shared_dirs, []).push('log')
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
  #invoke :'rvm:use', 'ruby-2.5.0@default'
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  command %(gem install bundler)
  #command %[touch "#{fetch(:shared_path)}/config/database.yml"]
  #command %[touch "#{fetch(:shared_path)}/config/secrets.yml"]
  #command %[touch "#{fetch(:shared_path)}/config/puma.rb"]
  #comment "Be sure to edit '#{fetch(:shared_path)}/config/database.yml', 'secrets.yml' and puma.rb."
  # command %{rbenv install 2.3.0 --skip-existing}
end

task setup: :remote_environment do
  deploy_to   = fetch(:deploy_to)
  shared_path = fetch(:shared_path)
  command %(sudo mkdir -p "#{deploy_to}")
  command %(sudo chown -R  "#{deploy_to}")

  command %(mkdir -p "#{shared_path}/log")
  command %(chmod g+rx,u+rwx "#{shared_path}/log")

  command %(mkdir -p "#{shared_path}/config")
  command %(chmod g+rx,u+rwx "#{shared_path}/config")

  command %(mkdir -p "#{shared_path}/db")
  command %(chmod g+rx,u+rwx "#{shared_path}/db")

  command %(mkdir -p "#{shared_path}/upload")
  command %(chmod g+rx,u+rwx "#{shared_path}/upload")

  command %(touch "#{shared_path}/config/database.yml")
  command %(touch "#{shared_path}/config/secrets.yml")
  command %(echo "-----> Be sure to edit '#{shared_path}/config/database.yml' and 'secrets.yml'.")

  command %(
    repo_host=`echo $repo | sed -e 's/.*@//g' -e 's/:.*//g'` &&
    repo_port=`echo $repo | grep -o ':[0-9]*' | sed -e 's/://g'` &&
    if [ -z "${repo_port}" ]; then repo_port=22; fi &&
    ssh-keyscan -p $repo_port -H $repo_host >> ~/.ssh/known_hosts
  )
end

desc "Deploys the current version to the server."
task deploy: :environment do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'whenever:update'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
      end
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
