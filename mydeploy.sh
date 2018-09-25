#!/usr/bin/env bash
# Executing the following via 'ssh ubuntu@18.222.197.62 -p 22 -A -tt':
#
#!/usr/bin/env bash

# Go to the deploy path
cd "/var/www/example" || (
echo "! ERROR: not set up."
echo "The path '/var/www/example' is not accessible on the server."
echo "You may need to run 'mina setup' first."
false
) || exit 15

# Check releases path
if [ ! -d "/var/www/example/releases" ]; then
echo "! ERROR: not set up."
echo "The directory '/var/www/example/releases' does not exist on the server."
echo "You may need to run 'mina setup' first."
exit 16
fi

# Check lockfile
if [ -e "deploy.lock" ]; then
echo "! ERROR: another deployment is ongoing."
echo "The file 'deploy.lock' was found. File was last modified at $(stat -c %y deploy.lock)"
echo "If no other deployment is ongoing, run 'mina deploy:force_unlock' to delete the file."
exit 17
fi

# Determine $previous_path and other variables
[ -h "/var/www/example/current" ] && [ -d "/var/www/example/current" ] && previous_path=$(cd "/var/www/example/current" >/dev/null && pwd -LP)
build_path="./tmp/build-$(date +%s)$RANDOM"

version="$((`ls -1 /var/www/example/releases | sort -n | tail -n 1`+1))"
release_path="/var/www/example/releases/$version"

# Sanity check
if [ -e "$build_path" ]; then
echo "! ERROR: Path already exists."
exit 18
fi

# Bootstrap script (in deployer)
(
echo "-----> Creating a temporary build path"
touch "deploy.lock" &&
mkdir -p "$build_path" &&
cd "$build_path" &&
(
  echo "-----> Loading rbenv" &&
  export RBENV_ROOT="$HOME/.rbenv" &&
  export PATH="$HOME/.rbenv/bin:$PATH" &&
  if ! which rbenv >/dev/null; then
    echo "! rbenv not found"
    echo "! If rbenv is installed, check your :rbenv_path setting."
    exit 1
  fi &&
  eval "$(rbenv init -)" &&
  echo "-----> Deploying example to 18.222.197.62:/var/www/example" &&
  pwd &&
  if [ ! -d "/var/www/example/scm/objects" ]; then
    echo "-----> Cloning the Git repository"
    git clone "https://github.com/KhrystynaInzhuvatova/example.git" "/var/www/example/scm" --bare
  else
    echo "-----> Fetching new git commits"
    (cd "/var/www/example/scm" && git fetch "https://github.com/KhrystynaInzhuvatova/example.git" "master:master" --force)
  fi &&
  echo "-----> Using git branch 'master'" &&
  git clone "/var/www/example/scm" . --recursive --branch "master" &&
  echo "-----> Using this git commit" &&
  git rev-parse HEAD > .mina_git_revision &&
  git --no-pager log --format="%aN (%h):%n> %s" -n 1 &&
  rm -rf .git &&
  echo "-----> Symlinking shared paths" &&
  if [ ! -d  "/var/www/example/shared/vendor/bundle" ]; then
    echo "! ERROR: not set up."
    echo "The directory '/var/www/example/shared/vendor/bundle' does not exist on the server"
    echo "You may need to run 'mina setup' first"
    exit 18
  fi &&
  mkdir -p ./vendor &&
  rm -rf "./vendor/bundle" &&
  ln -s "/var/www/example/shared/vendor/bundle" "./vendor/bundle" &&
  if [ ! -d  "/var/www/example/shared/log" ]; then
    echo "! ERROR: not set up."
    echo "The directory '/var/www/example/shared/log' does not exist on the server"
    echo "You may need to run 'mina setup' first"
    exit 18
  fi &&
  mkdir -p . &&
  rm -rf "./log" &&
  ln -s "/var/www/example/shared/log" "./log" &&
  if [ ! -d  "/var/www/example/shared/tmp/cache" ]; then
    echo "! ERROR: not set up."
    echo "The directory '/var/www/example/shared/tmp/cache' does not exist on the server"
    echo "You may need to run 'mina setup' first"
    exit 18
  fi &&
  mkdir -p ./tmp &&
  rm -rf "./tmp/cache" &&
  ln -s "/var/www/example/shared/tmp/cache" "./tmp/cache" &&
  if [ ! -d  "/var/www/example/shared/public/assets" ]; then
    echo "! ERROR: not set up."
    echo "The directory '/var/www/example/shared/public/assets' does not exist on the server"
    echo "You may need to run 'mina setup' first"
    exit 18
  fi &&
  mkdir -p ./public &&
  rm -rf "./public/assets" &&
  ln -s "/var/www/example/shared/public/assets" "./public/assets" &&
  if [ ! -d  "/var/www/example/shared/log" ]; then
    echo "! ERROR: not set up."
    echo "The directory '/var/www/example/shared/log' does not exist on the server"
    echo "You may need to run 'mina setup' first"
    exit 18
  fi &&
  mkdir -p . &&
  rm -rf "./log" &&
  ln -s "/var/www/example/shared/log" "./log" &&
  ln -sf "/var/www/example/shared/config/secrets.yml" "./config/secrets.yml" &&
  ln -sf "/var/www/example/shared/db/production.sqlite3" "./db/production.sqlite3" &&
  echo "-----> Installing gem dependencies using Bundler" &&
  bundle install --without development test --path "vendor/bundle" --deployment &&
  if diff -qrN "/var/www/example/current/db/migrate" "./db/migrate" 2>/dev/null
  then
    echo "-----> DB migrations unchanged; skipping DB migration"
  else
    echo "-----> Migrating database"
        RAILS_ENV="production" bundle exec rake db:migrate
  fi &&
  RAILS_ENV="production" bundle exec rails db:seed &&
  if diff -qrN "/var/www/example/current/vendor/assets/" "./vendor/assets/" 2>/dev/null && diff -qrN "/var/www/example/current/app/assets/" "./app/assets/" 2>/dev/null
  then
    echo "-----> Skipping asset precompilation"
  else
    echo "-----> Precompiling asset files"
        RAILS_ENV="production" bundle exec rake assets:precompile
  fi &&
  echo "-----> Cleaning up old releases (keeping 5)" &&
  (cd /var/www/example/releases && count=$(ls -A1 | sort -rn | wc -l) && remove=$((count > 5 ? count - 5 : 0)) && ls -A1 | sort -rn | tail -n $remove | xargs rm -rf {} && cd -)
) &&
echo "-----> Deploy finished"
) &&

#
# Build
(
echo "-----> Building"
echo "-----> Moving build to $release_path"
mv "$build_path" "$release_path" &&
cd "$release_path" &&
(
true
) &&
echo "-----> Build finished"

) &&

#
# Launching
# Rename to the real release path, then symlink 'current'
(
echo "-----> Launching"
echo "-----> Updating the /var/www/example/current symlink" &&
ln -nfs "$release_path" "/var/www/example/current"
) &&

# ============================
# === Start up server => (in deployer)
(
cd "/var/www/example/current"
  (cd /var/www/example/current && mkdir -p tmp/ && touch tmp/restart.txt && cd -) &&
  echo "-----> Loading rbenv" &&
  export RBENV_ROOT="$HOME/.rbenv" &&
  export PATH="$HOME/.rbenv/bin:$PATH" &&
  if ! which rbenv >/dev/null; then
    echo "! rbenv not found"
    echo "! If rbenv is installed, check your :rbenv_path setting."
    exit 1
  fi &&
  eval "$(rbenv init -)" &&
  echo "-----> Restart Puma -- phased..." &&
  if [ -e "/var/www/example/shared/tmp/sockets/pumactl.sock" ]; then
    if [ -e "/var/www/example/shared/config/puma.rb" ]; then
      cd /var/www/example/current && RAILS_ENV="production" bundle exec pumactl -F /var/www/example/shared/config/puma.rb phased-restart
    else
      cd /var/www/example/current && RAILS_ENV="production" bundle exec pumactl -S /var/www/example/shared/tmp/sockets/puma.state -C "unix:///var/www/example/shared/tmp/sockets/pumactl.sock" --pidfile /var/www/example/shared/tmp/pids/puma.pid phased-restart
    fi
  else
    echo 'Puma is not running!';
  fi
) &&

# ============================
# === Complete & unlock
(
rm -f "deploy.lock"
echo "-----> Done. Deployed version $version"
) ||

# ============================
# === Failed deployment
(
echo "! ERROR: Deploy failed."



echo "-----> Cleaning up build"
[ -e "$build_path" ] && (
  rm -rf "$build_path"
)
[ -e "$release_path" ] && (
  echo "Deleting release"
  rm -rf "$release_path"
)
(
  echo "Unlinking current"
  [ -n "$previous_path" ] && ln -nfs "$previous_path" "/var/www/example/current"
)

# Unlock
rm -f "deploy.lock"
echo "OK"
exit 19
)
 
       [96mElapsed time: 0.00 seconds[0m
