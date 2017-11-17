# Active Job Reporter
Monitoring and reporting for ActiveJob.

[![Gem](https://img.shields.io/gem/v/active_job_reporter.svg)](https://rubygems.org/gems/active_job_reporter)
[![Travis](https://img.shields.io/travis/podemos-info/active_job_reporter/master.svg)](https://travis-ci.org/podemos-info/active_job_reporter)
[![Codecov](https://img.shields.io/codecov/c/github/podemos-info/active_job_reporter.svg)](https://codecov.io/gh/podemos-info/active_job_reporter)

## Features
* Minimalistic approach to ActiveJob monitoring, database based to avoid additional dependencies.
* Filter jobs by status (`enqueued`, `running` or `finished`), user, resource or result (`ok`, `error` or custom).
* Messages log by job.
* Automatic basic exception handling during errors.
* Allows to override built-in Job model.

## Installation
1. Add this line to your application's Gemfile:

```ruby
gem 'active_job_reporter'
```

2. Update bundle

```bash
$ bundle
```

3. Run installer 

Add `jobs`, `job_objects` and `job_messages` tables to your database and an initializer file for configuration:

```bash
$ bundle exec rails generate active_job_reporter:install
$ bundle exec rake db:migrate
```

## Usage

1. Add `ReportableJob` concern to your jobs. You can add to `ApplicationJob` to avoid adding to every job. Jobs will be tracked automatically.

```ruby
include ActiveJobReporter::ReportableJob
```

2. Define `current_user` method in your jobs to relate them to users. Use `arguments` variable to retrieve `perform` call arguments. Using keyword arguments with the same name would allow you to define at `ApplicationJob`.

```ruby
def current_user
  arguments.first&.fetch(:admin_user, nil)
end
```

3. Define `related_objects` method in your jobs to relate them to other application records.

```ruby
def related_objects
  [
    arguments.first&.fetch(:order, nil), 
    *arguments.first&.fetch(:items, [])
  ].compact
end
```

4. Add log messages and result code inside your jobs `perform` methods. `log` method allows to specify type of message and complex messages (stored as JSON in database). Use `self.result` to store the result of the job (won't be saved until the end of the process). If not specified, result will be `:ok` or `:error`, when the `perform` method raises an exception.

```ruby
  def perform(**params)
    if has_issues?
      log :issues, raw: "raw test message"
      self.result = :issues
    end

    if params[:raise]
      a = 1 / 0
    end

    log :user, key: "test.user_message.#{result}", params: { user_id: 1, number: 12 }
  end
```

5. Application models related to jobs can use the `HasJobs` concern to simplify access to them.

```ruby
class Resource < ApplicationRecord
  include ActiveJobReporter::HasJobs
end
```

Then, access to jobs can be made from `jobs` association method.

```ruby
2.4.1 :001 > Resource.first.jobs.count
 => 1
2.4.1 :002 > Resource.first.jobs.running.count
 => 0
```

6. If an application `Job` model is needed (to extend it or avoid using a qualified name), it can be defined using the `JobConcern` concern and specifying the class name in the initializer file.

```ruby
# in app/models/job.rb
class Job < ActiveRecord::Base
  include ActiveJobReporter::JobConcern
end

# in config/initializers/active_job_reporter.rb
ActiveJobReporter.configure do |config|
  ...

  # The class name for jobs
  config.job_class_name = "Job"

  ...
end
```

## Changelog

#### 0.1.2

* Tests fixes.

#### 0.1.1

* Fixed deprecated use of class instead of class name in `belongs_to`.

#### 0.1.0

* First version.

## Contributing
Issues and PRs are welcomed.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
