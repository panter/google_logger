# frozen_string_literal: true

RSpec.describe GoogleLogger::ControllerLogging do
  class TestClass
    require 'action_controller'

    include GoogleLogger::ControllerLogging

    attr_reader :params, :request

    def initialize(params, request = nil)
      @params = ActionController::Parameters.new(params)
      @request = request
    end

    def method_with_logging
      log_request_to_google do
        'doing controller method stuff'
      end
    end

    def method_with_logging_that_raises_exception(exception)
      log_request_to_google do
        raise exception
      end
    end
  end

  let(:params) { { password: 'abc123', b: 2, c: '3' } }

  let(:request) {
    request_double = double('request')
    allow(request_double).to receive(:ip) { '0.1.2.3' }
    allow(request_double).to receive(:original_url) { 'http://abc.def:1234/something' }
    allow(request_double).to receive(:method) { 'POST' }

    request_double
  }

  before :all do
    configure_google_logger
  end

  let(:class_with_module) do
    TestClass.new(params, request)
  end

  it 'returns params without secret params values' do
    log_params = class_with_module.send(:google_log_params)

    GoogleLogger.configuration.secret_params.each do |key|
      params.delete(key)
      expect(log_params[key]).to eq(GoogleLogger.configuration.secret_param_value)
    end

    expect(log_params).to include(log_params)
  end

  context 'when acting as an around filter' do
    it 'logs a request' do
      class_with_module.method_with_logging
    end

    it 'logs any uncaught exceptions' do
      exception = StandardError.new('testing exception catching')

      expect {
        class_with_module.method_with_logging_that_raises_exception(exception)
      }.to raise_error(exception)
    end
  end
end