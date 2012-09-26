wistia-uploader
===============

A simple command line media upload client for Wistia users.

Run 'bin/wistia-uploader -h' for additional information.

Configuration
-------------

While not required for use, defaults for various required parameters may be
supplied via the '~/.wistia.conf' configuration file in the form of simple
key/value pairs. Example:

    # Credentials for foo.wistia.com
    api_password = <API_PASSWORD>
    project_id = <PROJECT_HASHED_ID>

A Wistia 'contact_id' may also be specified, otherwise the account owner will
be inferred from the project.

Copyright
---------

Copyright (c) 2012 Jason Lawrence of Wistia, Inc.
