Main Repo Status:

<a href="https://codeclimate.com/github/AgileVentures/projectscope_mvp"><img src="https://codeclimate.com/github/AgileVentures/projectscope_mvp/badges/gpa.svg" /></a>
<a href="https://travis-ci.org/AgileVentures/projectscope_mvp"><img src="https://travis-ci.org/AgileVentures/projectscope_mvp.svg?branch=master"></a>

CS169 Group Forked Repo Status:

<a href="https://codeclimate.com/github/DrakeW/projectscope"><img src="https://codeclimate.com/github/DrakeW/projectscope/badges/gpa.svg" /></a>
<a href="https://travis-ci.org/DrakeW/projectscope"><img src="https://travis-ci.org/DrakeW/projectscope.svg?branch=develop"></a>

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
database attributes at rest.  It is safe to version this file.  The secrets
in this file are managed [as described in this article.](saasbook.blogspot.com/2016/08/keeping-secrets.html)

# Creating new metric gems

Each metric gem *must* provide the following methods:

* `initialize(credentials={}, raw_data=nil)` Constructor that takes any credentials needed for the gem to contact any remote services, as a hash, and optionally takes an initial set of raw data (i.e. what would be delivered by the API of the remote service)
* `score`: computes the metric score (normalized from 0 to 100) given the current raw data
* `refresh`: refresh raw data from remote API
* `raw_data=(new_data)`: explicitly set raw data, rather than fetching from remote API
* `raw_data`: return most recent raw data
* `image`: return an image representation of the current metric state.  At the moment this "image" will be rendered as HTML, so you can in principle return a link to a remote image, but we recommend returning an SVG image since this is extremely flexible and can be rendered as interactive HTML, allowing mouse over explanation on parts of the image etc.

- https://en.wikipedia.org/wiki/Scalable_Vector_Graphics
- https://css-tricks.com/how-to-make-charts-with-svg/

If the metric gem provides the class method `credentials`, it should return a list of strings that are the names of the configuration variables the gem expects to find in the `credentials` hash passed to it.  Note that these are configuration variables for an _instance_ of the metric, for example, the GitHub or PivotalTracker token to access a particular private repo or account.  (Application-wide configuration variables are handled separately.)

TODO
----

* [ ] should we be passing global project tokens via project metric settings? (github gem relying on ENV var)
* [ ] get versions of the gems stored in db for future reference?
* [ ] get JSON API set up so that other services can consume our data
* [ ] get some sad path testing in place
* [ ] get some rspecs on the individual models?
* [ ] make cukes higher level?
