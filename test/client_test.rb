require 'rubygems'
require 'test/unit'
require 'yaml'

$:.unshift File.expand_path('../../lib', __FILE__)
require 'romniture'

class ClientTest < Test::Unit::TestCase

  def setup
    config = YAML::load(File.open("test/config.yml"))
    @config = config["omniture"]

    @client = ROmniture::Client.new(
      @config["username"],
      @config["shared_secret"],
      @config["environment"],
      :verify_mode => @config['verify_mode'],
      :wait_time => @config["wait_time"]
    )
  end

  def test_get_report_suites
    response = @client.get_report_suites

    assert_instance_of Hash, response, "Returned object is not a hash."
    assert(response.has_key?("report_suites"), "Returned hash does not contain any report suites.")
  end

  def test_enqueue_report
    response = @client.enqueue_report({
      "reportDescription" => {
        "reportSuiteID" => "#{@config["report_suite_id"]}",
        "dateFrom" => "2014-07-01",
        "dateTo" => "2014-07-07",
        "metrics" => [{"id" => "pageviews"}]
    }})

    assert_instance_of Hash, response, "Returned object is not a hash."
    assert(response.has_key?("reportID"), "Returned hash has no data!")
  end

  def test_enqueue_report_with_invalid_metric_raises
    assert_raises ROmniture::Exceptions::RequestInvalid do
      response = @client.enqueue_report({
        "reportDescription" => {
          "reportSuiteID" => "#{@config["report_suite_id"]}",
          "dateFrom" => "2014-07-01",
          "dateTo" => "2014-07-07",
          "metrics" => [{"id" => "INVALID_METRIXXXX"}]
      }})
    end
  end

  def test_enqueue_report_with_invalid_metric_raises
    assert_raises ROmniture::Exceptions::RequestInvalid do
      response = @client.enqueue_report({
        "reportDescription" => {
          "reportSuiteID" => "INVALID_REPORT_SUITE_ID",
          "dateFrom" => "2014-07-01",
          "dateTo" => "2014-07-07",
          "metrics" => [{"id" => "pageVIews"}]
      }})
    end
  end

  def test_get_queue
    response = @client.get_queue
    assert_instance_of Array, response, "Returned object is not an array."
  end

  def test_get_enqueued_report_wo_elements
    response = @client.enqueue_report({
      "reportDescription" => {
        "reportSuiteID" => "#{@config["report_suite_id"]}",
        "dateFrom" => "2014-07-01",
        "dateTo" => "2014-07-07",
        "metrics" => [{"id" => "pageviews"}]
    }})
    report_id = response["reportID"]

    response = @client.get_enqueued_report(report_id)

    assert_instance_of Hash, response, "Returned object is not a hash."
    assert(response["report"].has_key?("data"), "Returned hash has no data!")
  end
end
