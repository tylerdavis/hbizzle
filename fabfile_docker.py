import re
from fabric.api import cd, env, local, lcd, run


# Tasks

def deploy():
  pass

def production():
  env.host_string = "beta.hbizzle.com"
  env.user = "rails"

def push_to_git():
  local("git add -p && git commit")
  local("git push")

def run_vm_test():
  machine = 'default'
  __run_vm(machine)
  __vm_ssh_config(machine)
  __pull_git('rails/hbizzle')
  __build_hbizzle()
  __suspend_vm(machine)



# Privates

VM_DIR = "/Users/tylerdavis/Development/docker/"

def __build_hbizzle():
  with cd('rails'):
    run('docker build -rm -t hbizzle .')
    run('CONTAINER=$(docker run -d hbizzle ls) && docker commit $CONTAINER tylerdavis/hbizzle')
    run('docker push tylerdavis/hbizzle')

def __pull_hbizzle():
  with cd('hbizzle'):
    git pull

def __pull_git(directory, git_repository='origin', git_branch='master'):
  # Go to directory, pull specified 
  with cd(directory):
    run('git pull ' + git_repository + ' ' + git_branch)

def __resume_vm(machine):
  # Resume a suspended vm
  with lcd(VM_DIR):
    local("vagrant resume " + machine)

def __run_vm(machine):
  # Check vm state
  status = __vm_status(machine)
  print(status)
  if status == 'running':
    pass
  elif status == 'saved':
    __resume_vm(machine);
  elif status == 'poweroff':
    __start_vm(machine)

def __start_vm(machine):
  # Start a halted vm
  with lcd(VM_DIR):
    local("vagrant up " + machine)

def __suspend_vm(machine):
  # Suspend vm
  with lcd(VM_DIR):
    local("vagrant suspend " + machine)

def __vm_status(machine):
  # vm statuses: running, saved, poweroff
  with lcd(VM_DIR):
    status = local("vagrant status " + machine, capture=True)
    matches = re.findall(r'default\s+(\w+)', status, re.M|re.I)
    if matches:
      return matches[0]
    else:
      raise Exception("VM not found.")

def __vm_ssh_config(machine):
  # vm ssh config dictionary
  with lcd(VM_DIR):
    config = local("vagrant ssh-config " + machine, capture=True)
    env.host_string = re.findall(r'HostName\s(.+)', config, re.M|re.I)[0]
    env.user = re.findall(r'User\s(.+)', config, re.M|re.I)[0]
    env.key_filename = re.findall(r'IdentityFile\s(.+)', config, re.M|re.I)[0]
    env.port = re.findall(r'Port\s(.+)', config, re.M|re.I)[0]

