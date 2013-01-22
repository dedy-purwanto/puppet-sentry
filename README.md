puppet-sentry
=============

This is a puppet module for installing sentry.

One of the tricky things
about installing sentry is that when you call``sentry
--config=foobar.py syncdb/upgrade``, it will interactively ask you for
superuser creation, which is _not_ possible in puppet, since puppet runs
in non-interactive mode.

puppet-sentry handles this problem by providing a predefined superuser
object in json format, and an extra argument for sentry
initialization. This way, you can install sentry with a predefined
superuser without any interaction at all.
