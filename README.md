<a href="https://codeclimate.com/github/AgileVentures/projectscope_mvp"><img src="https://codeclimate.com/github/AgileVentures/projectscope_mvp/badges/gpa.svg" /></a>
<a href="https://travis-ci.org/AgileVentures/projectscope_mvp"><img src="https://travis-ci.org/AgileVentures/projectscope_mvp.svg?branch=master"></a>
# MVP dashboard for ProjectScope

A dashboard to show project metrics such as those supported by gems like
[project_metric_code_climate](https://github.com/AgileVentures/project_metric_code_climate),
[project_metric_github](https://github.com/AgileVentures/project_metric_github),
and others, using the [project_metrics](https://github.com/AgileVentures/project_metrics) gem to wrap
them for consumption by a Rails app

Standing up an instance
-----------------------

Get set up with a Github Access token (for the github gem):

https://help.github.com/articles/creating-an-access-token-for-command-line-use/

Then run rails server like so:

```GITHUB_ACCESS_TOKEN=<YOUR_ACCESS_TOKEN> rails s```

Then you can use the web interface to create projects.  Both the above gems (github, codeclimate), require a key pair of

"url" "http://github.com/AgileVentures/LocalSupport"

specifying the github url for the project.  In order to generate sample metrics to show up in the project index page,
run rails console like so:

```GITHUB_ACCESS_TOKEN=<YOUR_ACCESS_TOKEN> rails c```

if you then run

```Project.all.each &:resample_all_metrics```

on the console (and the GITHUB_ACCESS_TOKEN env var is set) it will generate a set of samples you can then see in the interface

or execute

```rake project:resample_all```

# Managing the app secret

The file `config/application.yml.asc` is a symmetric-key-encrypted YAML
file that itself contains the encryption keys for encrypting sensitive
database attributes at rest.  It is safe to version this file.

Let us call the key used to encrypt this file the "main secret".

**This means** the file `config/application.yml` must be created on the
fly (**and should never be
versioned**), by decrypting `application.yml.asc` with the main
secret, to run the app or its tests.  Here's how to do it:

* On your local machine for development: run the following command line

```sh
export APP_SECRET=<the application secret goes here>
gpg --passphrase "$APP_SECRET" --output config/application.yml --decrypt config/application.yml.asc
```

* In CI: Set an environment variable APP_SECRET on Travis to the value
of the main secret.  The `.travis.yml` file specifies  a `before_script`
step that runs the above command line to create `config/application.yml`.

* In production: first create the `config/application.yml` file locally
as above, then run `figaro heroku:set -e production`

If the value of `APP_SECRET` or any of the values in
`config/application.yml` are changed, you must:

0. regenerate `config/application.yml.asc` with `gpg --passphrase "$APP_SECRET" --output config/application.yml.asc --armor --encrypt config/application.yml"

0. commit the new version of `config/application.yml.asc`

0. if `$APP_SECRET` changed, change the value of the corresponding
environment variable in CI, as above

TODO
----

* [ ] should we be passing global project tokens via project metric settings? (github gem relying on ENV var)
* [ ] get versions of the gems stored in db for future reference?
* [ ] get JSON API set up so that other services can consume our data
* [ ] get some sad path testing in place
* [ ] get some rspecs on the individual models?
* [ ] make cukes higher level?
