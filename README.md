# fredit: front-end edit

fredit is a simple, no-frills Rails Engine that lets you edit your Rails
application's view templates, css stylesheets, and javascript files
(a.k.a front-end files) through the browser.

fredit injects an edit link into every view template. These edit links
are visible wherever the template is rendered, whether it is a layout,
a page, or a partial. 

<img style="width:300px" src="https://github.com/danchoi/fredit/raw/master/screens/links.png"/>

By clicking on these links, you call up a edit page that will let you
directly edit the source. An update button lets you save these changes
and alter the underlying source files.

<img style="width:300px" src="https://github.com/danchoi/fredit/raw/master/screens/fredit.png"/>

In addition to view templates, stylesheets and javascript files are
accessible through a file selection drop down at the top of the fredit
edit page. 

You can also create and delete front-end files on the fredit edit page.

**NOTE: Currently only the ERB Rails template handler is supported.**
You are welcome to fork and add support for Haml and other template
handlers. 


## Why fredit?

On a current Rails project, I needed to delegate responsibility for
improving the user interface to another person. This person:

* is not a Rails programmer
* knows HTML and CSS
* can make sense of ERB and Rails partials after a few minutes of
  explanation
* can use a web browser interface to edit files



## Install

Put something like this in the `Gemfile` of your Rails app:

    group :staging do
      gem 'fredit'
    end

and then run `RAILS_ENV=staging bundle install`, adjusting the
`RAILS_ENV` to your target environment.




## fredit and git 

fredit assumes that the Rails instance it is running on is a cloned git
repository. 

When you save your changes, fredit will make a git commit on
the git branch this instance of Rails application.

Clicking on fredit link will take you to a simple web-based editor where
you can directly edit the source of the view template.



commit these edits on a git branch and attribute commits to the author



## License

Fredit is distributed under the MIT-LICENSE.
