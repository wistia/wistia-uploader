# wistia-uploader

A command line media upload client for Wistia users.

Run 'bin/wistia-uploader -h' for additional information.

## Requirements

wistia-uploader works with Ruby 1.8.7 and 1.9.3. Earlier versions of 1.8 and 1.9 may work but have not been tested.

## Configuration
-------------

While not required for use, defaults for various required parameters may be
supplied via the '~/.wistia.conf' configuration file in the form of simple
key/value pairs. Example:

    # Credentials for foo.wistia.com
    api_password = <API_PASSWORD>
    project_id = <PROJECT_HASHED_ID>

A Wistia 'contact_id' may also be specified, otherwise the account owner will
be inferred from the project.
