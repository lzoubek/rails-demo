require "hawkularclient"

class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  class MetricsReporter

    def initialize
      tenant_id = "hawkular.org"
      # create hawkular metrics client <1>
      @client = Hawkular::Metrics::Client::new("http://localhost:8080/hawkular/metrics","","",{:tenant => tenant_id})
      # create tenant (if it does not exist)
      if @client.tenants.query.select { |tenant|  tenant.id == tenant_id}.empty?
        @client.tenants.create tenant_id
      end
    end

    def around(controller, &block)
      now = Time.now
      block.call
      time_spent = Time.now - now
      # metric ID must be unique within tenant
      gauge = "App.#{controller.class.name}:#{controller.params[:action]}"
      # make sure metric definition is created <2>
      @client.gauges.create({:id => gauge, :tags => {:app => "App"}}) rescue
      # report time in milliseconds
      @client.gauges.push_data(gauge ,{:value => time_spent * 1000})
    end

  end
  around_filter MetricsReporter::new

end
