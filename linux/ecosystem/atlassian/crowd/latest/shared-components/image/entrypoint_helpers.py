import sys
import os
import pwd
import shutil
import logging
import jinja2 as j2
import uuid
import base64


logging.basicConfig(level=logging.DEBUG)


######################################################################
# Setup inputs and outputs

# Import all ATL_* and Dockerfile environment variables. We lower-case
# these for compatability with Ansible template convention. We also
# support CATALINA variables from older versions of the Docker images
# for backwards compatability, if the new version is not set.
env = {k.lower(): v
       for k, v in os.environ.items()}


# Setup Jinja2 for templating
jenv = j2.Environment(
    loader=j2.FileSystemLoader('/opt/atlassian/etc/'),
    autoescape=j2.select_autoescape(['xml']))


######################################################################
# Utils

def set_perms(path, user, group, mode):
    try:
        shutil.chown(path, user=user, group=group)
    except PermissionError:
        logging.warning(f"Could not chown path {path} to {user}:{group} due to insufficient permissions.")

    try:
        os.chmod(path, mode)
    except PermissionError:
        logging.warning(f"Could not chmod path {path} to {mode} due to insufficient permissions.")

def set_tree_perms(path, user, group, mode):
    set_perms(path, user, group, mode)
    for dirpath, dirnames, filenames in os.walk(path):
        set_perms(path, user, group, mode)
        for filename in filenames:
            set_perms(path, user, group, mode)

def check_perms(path, uid, gid, mode):
    stat = os.stat(path)
    return all([
        stat.st_uid == int(uid),
        stat.st_gid == int(gid),
        stat.st_mode & mode == mode
    ])

def gen_cfg(tmpl, target, user='root', group='root', mode=0o644, overwrite=True):
    if not overwrite and os.path.exists(target):
        logging.info(f"{target} exists; skipping.")
        return

    logging.info(f"Generating {target} from template {tmpl}")
    cfg = jenv.get_template(tmpl).render(env)
    try:
        with open(target, 'w') as fd:
            fd.write(cfg)
    except (OSError, PermissionError):
        logging.warning(f"Permission problem writing '{target}'; skipping")
    else:
        set_tree_perms(target, user, group, mode)

def gen_container_id():
    env['uuid'] = uuid.uuid4().hex
    with open('/etc/container_id') as fd:
        lcid = fd.read()
        if lcid != '':
            env['local_container_id'] = lcid

def str2bool(v):
    if str(v).lower() in ('yes', 'true', 't', 'y', '1'):
        return True
    return False

def unset_secure_vars():
    secure_keywords = ('PASS', 'SECRET', 'TOKEN')
    for key in os.environ:
        if any(kw in key.upper() for kw in secure_keywords):
            logging.warning(f"Unsetting environment var {key}")
            del os.environ[key]


######################################################################
# Application startup utilities

def check_permissions(home_dir):
    """Ensure the home directory is set to minimal permissions"""
    if str2bool(env.get('set_permissions') or True) and check_perms(home_dir, env['run_uid'], env['run_gid'], 0o700) is False:
        set_tree_perms(home_dir, env['run_user'], env['run_group'], 0o700)
        logging.info(f"User is currently root. Will change directory ownership and downgrade run user to {env['run_user']}")


def drop_root(run_user):
    logging.info(f"User is currently root. Will downgrade run user to {run_user}")
    pwd_entry = pwd.getpwnam(run_user)

    os.environ['USER'] = run_user
    os.environ['HOME'] = pwd_entry.pw_dir
    os.environ['SHELL'] = pwd_entry.pw_shell
    os.environ['LOGNAME'] = run_user
    os.setgid(pwd_entry.pw_gid)
    os.setuid(pwd_entry.pw_uid)


def write_pidfile():
    app_home = env[f"{env['app_name'].lower()}_home"]
    pidfile = f"{app_home}/docker-app.pid"
    with open(pidfile, 'wt', encoding='utf-8') as fd:
        pid = os.getpid()
        fd.write(str(pid))


def exec_app(start_cmd_v, home_dir, name='app', env_cleanup=False):
    """Run the supplied application startup command.

    Arguments:
    start_cmd -- A list of the command and its arguments.
    home_dir -- Application home directory.
    name -- (Optional) The name to display in the log message.
    env_cleanup -- (Default: False) Remove possibly sensitive env-vars.
    """
    if os.getuid() == 0:
        check_permissions(home_dir)
        drop_root(env['run_user'])

    write_pidfile()

    if env_cleanup:
        unset_secure_vars()

    cmd = start_cmd_v[0]
    args = start_cmd_v
    logging.info(f"Running {name} with command '{cmd}', arguments {args}")
    os.execv(cmd, args)
