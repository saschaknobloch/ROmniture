# romniture
To be pronounced...RAWWWRROMNITURE

## fork you
this is a fork of [msukmanowskys Ruby Omniture Gem](https://github.com/msukmanowsky/ROmniture). This fork introduces the 
following changes:
* Match Omniture API ver. 1.4 requirements
* Have a number of maximum tries before a request for a pending report times out
* Breakdown of ROmniture.client methods, have 1 method for each Omniutre request method
* Authentication via OAuth2 possible (jaja, gleich, gleich)

## what is it
romniture is a minimal Ruby wrapper to [Omniture's REST API](http://developer.omniture.com). It follows a design policy similar to that of [sucker](https://rubygems.org/gems/sucker) built for Amazon's API.

Omniture's API is closed, you have to be a paying customer in order to access the data.

## installation
    [sudo] gem install romniture

## initialization and authentication
romniture requires you supply the `username`, `shared_secret` and `environment` which you can access within the Company > Web Services section of the Admin Console.  The environment you'll use to connect to Omniture's API depends on which data center they're using to store your traffic data and will be one of:

* San Jose (https://api.omniture.com/admin/1.4/rest/)
* Dallas (https://api2.omniture.com/admin/1.4/rest/)
* London (https://api3.omniture.com/admin/1.4/rest/)
* San Jose Beta (https://beta-api.omniture.com/admin/1.4/rest/)
* Dallas (beta) (https://beta-api2.omniture.com/admin/1.4/rest/)
* Sandbox (https://api-sbx1.omniture.com/admin/1.4/rest/)

Here's an example of initializing with a few configuration options.

    client = ROmniture::Client.new(    	   
      username, 
      shared_secret, 
      :san_jose, 
      :verify_mode	=> nil	# Optionaly change the ssl verify mode.
      :log => true,    		# Optionally turn on logging (default: false)
      :wait_time => 1           # Amount of seconds to wait in between pinging (default: 0.25)
      :max_tries => 10          # Maximum tries of pings before timing out (default: 120)
      )
    
## usage

The ROmniture client exposes the following methods:

* `request(method, parameters)` - more generic used to make any kind of request
* `get_report_suites` - get the available report suites for a company
* `enqueue_report(parameters)` - enqueue a report 
* `get_queue` - get the reports which are still in the queue and not ready for fetching
* `get_enqueued_report(report_id)` - get the data for a previously enqueued report (if report is not ready it will retry as often as max_tries*wait_time)
* `get_metrics(report_suite_id)` - get all available metrics for a certain report suite

For reference, I'd recommend keeping [Omniture's Developer Portal](http://developer.omniture.com) open as you code .  It's not the easiest to navigate but most of what you need is there.

The response returned by either of these requests Ruby (parsed JSON).

## examples
    # Find all the company report suites
    client.get_report_suites

    # Enqueue a report
    client.enqueue_report({
      "reportDescription" => {
        "reportSuiteID" => "#{@config["report_suite_id"]}",
	"date" => "2014-07-01",
        "metrics" => [{"id" => "pageviews"}]
        }
    })

    # Fetch a report
    client.get_report(report_id)
