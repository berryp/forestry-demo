---
title: Mission won't sync
---

It's possible to get your local dscontent environment in a state where missions will fail to sync, with the following error (usually hidden in a much longer traceback)

```
Traceback (most recent call last):
  File "/opt/wwc/mainstack/server/containers/sessions/anonymous.py", line 344, in _starting_up
    yield
  File "/opt/wwc/mainstack/server/containers/sessions/anonymous.py", line 156, in initialize
    persistence, kw.get('procs', []), dependencies
  File "/opt/wwc/mainstack/server/containers/sessions/anonymous.py", line 247, in _add_implicit_dependencies
    persistence, procs
  File "/opt/wwc/mainstack/server/containers/sessions/anonymous.py", line 355, in _implicit_dependencies
    self._persistence_dependencies(persistence),
  File "/opt/wwc/mainstack/server/containers/sessions/anonymous.py", line 385, in _persistence_dependencies
    'contents': self.model.persistence.contents()
  File "/opt/wwc/mainstack/server/containers/models.py", line 742, in contents
    return self.contents_file.read()
  File "/opt/dsserver/lib/python3.6/site-packages/django/core/files/utils.py", line 19, in <lambda>
    read = property(lambda self: self.file.read)
  File "/opt/dsserver/lib/python3.6/site-packages/django/db/models/fields/files.py", line 51, in _get_file
    self._file = self.storage.open(self.name, 'rb')
  File "/opt/dsserver/lib/python3.6/site-packages/django/core/files/storage.py", line 38, in open
    return self._open(name, mode)
  File "/opt/dsserver/lib/python3.6/site-packages/django/core/files/storage.py", line 300, in _open
    return File(open(self.path(name), mode))
FileNotFoundError: [Errno 2] No such file or directory: '/opt/wwc/mainstack/server/media/sessions/dq-session-persistence-2'
```

You may find a similar issue around dependencies:

```
Traceback (most recent call last):
  File "manage.py", line 10, in <module>
    execute_from_command_line(sys.argv)
  File "/opt/dsserver/lib/python3.6/site-packages/django/core/management/__init__.py", line 367, in execute_from_command_line
    utility.execute()
  File "/opt/dsserver/lib/python3.6/site-packages/django/core/management/__init__.py", line 359, in execute
    self.fetch_command(subcommand).run_from_argv(self.argv)
  File "/opt/dsserver/lib/python3.6/site-packages/django/core/management/base.py", line 294, in run_from_argv
    self.execute(*args, **cmd_options)
  File "/opt/dsserver/lib/python3.6/site-packages/django/core/management/base.py", line 345, in execute
    output = self.handle(*args, **options)
  File "/opt/wwc/mainstack/server/missions/management/commands/sync_local_sources.py", line 63, in handle
    no_courses=options["no_courses"]
  File "/opt/wwc/mainstack/server/missions/sync/__init__.py", line 39, in sync_local_sources
    **kw
  File "/opt/wwc/mainstack/server/missions/sync/records.py", line 30, in wrapper_
    raise exc
  File "/opt/wwc/mainstack/server/missions/sync/records.py", line 27, in wrapper_
    results = apply()
  File "/opt/wwc/mainstack/server/missions/sync/records.py", line 14, in apply
    return fn(sync_record, *wargs, **wkw)
  File "/opt/wwc/mainstack/server/missions/sync/content.py", line 63, in sync
    sync_record, path, mission_folders, *args, **kw
  File "/opt/wwc/mainstack/server/missions/sync/content.py", line 611, in _sync_mission_directories
    force=force,
  File "/opt/wwc/mainstack/server/missions/sync/content.py", line 513, in _sync_outputs
    force=force,
  File "/opt/wwc/mainstack/server/missions/sync/content.py", line 323, in _generate_outputs
    for results in code.sync(mission, **options):
  File "/opt/wwc/mainstack/server/missions/sync/code.py", line 36, in sync
    results = screen_sync.results()
  File "/opt/wwc/mainstack/server/missions/sync/code.py", line 196, in results
    self._eval(dumpfile), {
  File "/opt/wwc/mainstack/server/missions/sync/code.py", line 214, in _eval
    return self._eval_code_screen(dumpfile)
  File "/opt/wwc/mainstack/server/missions/sync/code.py", line 225, in _eval_code_screen
    initial_code_results = self._run_initial_code()
  File "/opt/wwc/mainstack/server/missions/sync/code.py", line 241, in _run_initial_code
    results = self._setup_handler().run_code_and_get_context_and_variables(
  File "/opt/wwc/mainstack/server/missions/sync/code.py", line 295, in _setup_handler
    self._handler.setup(dynamic_dependencies=self._store)
  File "/opt/wwc/mainstack/server/missions/screenhandler.py", line 148, in setup
    self.setup_container_manager(*args, **kw)
  File "/opt/wwc/mainstack/server/missions/screenhandler.py", line 170, in setup_container_manager
    self.cm.setup_user_container(self.screen)
  File "/opt/wwc/mainstack/server/containers/compat/interfaces.py", line 118, in setup_user_container
    interface.setup_screen(screen)
  File "/opt/wwc/mainstack/server/containers/interfaces/interface.py", line 477, in wrapper
    result = fn(instance, *args, **kw)
  File "/opt/wwc/mainstack/server/containers/interfaces/interface.py", line 495, in wrapper
    result = fn(instance, *args, **kw)
  File "/opt/wwc/mainstack/server/containers/interfaces/runner.py", line 272, in setup_screen
    self._clean_up_previous_run(screen)
  File "/opt/wwc/mainstack/server/containers/interfaces/runner.py", line 243, in _clean_up_previous_run
    self.engine.dependencies.push(dependencies)
  File "/opt/wwc/mainstack/server/containers/engines/dependencies.py", line 130, in push
    [(path, self._dependency(spec)) for path, spec in pairs]
  File "/opt/wwc/mainstack/server/containers/engines/dependencies.py", line 66, in _bundle
    for path, dependency in dependencies if should_exclude(dependency)
  File "/opt/wwc/mainstack/server/containers/engines/dependencies.py", line 66, in <listcomp>
    for path, dependency in dependencies if should_exclude(dependency)
  File "/opt/wwc/mainstack/server/containers/engines/dependencies.py", line 58, in should_exclude
    hasattr(spec['contents'], 'read') and
  File "/opt/dsserver/lib/python3.6/site-packages/django/core/files/utils.py", line 19, in <lambda>
    read = property(lambda self: self.file.read)
  File "/opt/dsserver/lib/python3.6/site-packages/django/db/models/fields/files.py", line 51, in _get_file
    self._file = self.storage.open(self.name, 'rb')
  File "/opt/dsserver/lib/python3.6/site-packages/django/core/files/storage.py", line 38, in open
    return self._open(name, mode)
  File "/opt/dsserver/lib/python3.6/site-packages/django/core/files/storage.py", line 300, in _open
    return File(open(self.path(name), mode))
FileNotFoundError: [Errno 2] No such file or directory: '/opt/wwc/mainstack/server/media/dependencies/dq-mission-dependency-25188'
```

These indicates that either the persistence or dependency models are throwing an error during sync.

## To fix:

- Run `./dscontent manage shell_plus` to launch Django's shell plus
- Depending on the stack trace, do one of the following:
   - Run `Persistence.objects.all().delete()`
   - Run `Dependency.objects.all().delete()`
- Run `Session.objects.all().delete()`
- Close shell plus

You should now be able to sync your project without error.