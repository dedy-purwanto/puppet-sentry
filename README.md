puppet-sentry
=================

This is a puppet module for installing sentry. One of the tricky thing
about installing sentry is that when you calling ``sentry
--config=foobar.py syncdb/upgrade``, it will interactively ask you for
superuser creation, which is _not_ possible in puppet since they are
running in a non-interactive mode.

puppet-sentry handle this problem by providing a predefined superuser
information in a json format, and an extra arguments for sentry
initialization. This way, you can install sentry without with predefined
superuser without any interaction at all.
