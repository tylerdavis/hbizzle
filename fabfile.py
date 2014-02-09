from fabric.api import cd, env, local, run, sudo

##Hbizzle Specific

# Environments
def development():
  pass

def production():
  env.host_string = 'beta.hbizzle.com'
  env.user = 'rails'
  env.cwd ='/home/rails/hbizzle'

def staging():
  pass

# Tasks
def deploy():
  __pull('hbizzle')
  __bundle_install()
  rake('db:migrate')
  __restart('hbizzle')

def fetch():
  rake('fetch')

def rake(command):
  run('rake ' + command)

def rollback():
  run('git reset HEAD@{1}')
  __bundle_install()
  __restart('hbizzle')

def push(remote='origin', branch='master'):
  # Commit current build and push to remote
  local('git add -A -p && git commit')
  local('git push ' + remote + ' ' + branch)

def __bundle_install():
  run('bundle install')

def __pull(directory, repository='origin', branch='master'):
  # Go to directory, pull specified
  run('git pull ' + repository + ' ' + branch)

# Upstart commands
def __start(service):
  sudo('start ' + service, pty=False)

def __stop(service):
  sudo('stop ' + service, pty=False)

def __restart(service):
  sudo('restart ' + service, pty=False)