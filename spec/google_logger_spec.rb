# frozen_string_literal: true

require 'action_controller'

RSpec.describe GoogleLogger do
  let(:configuration) do
    {
      project_id: 'fake_project_id',
      credentials: 'fake_credentials',
      async: true,
      resource_type: 'k8s_container',
      resource_labels: {
        cluster_name: 'cluster1',
        namespace_name: 'namespace1',
        pod_name: 'pod_name1',
        container_name: 'container_name1'
      },
      secret_params: %i[secret_param1 secret_param2 secret_param3],
      secret_param_value: '***secret_param_value***'
    }
  end

  let(:config_keys_with_default_value) { %i[async resource_type resource_labels secret_params secret_param_value] }

  before :each do
    GoogleLogger.configuration = nil
  end

  it 'has a version number' do
    expect(GoogleLogger::VERSION).not_to be nil
  end

  context 'when configuring' do
    it 'values can be set' do
      described_class.configure do |config|
        configuration.each do |key, value|
          config.public_send("#{key}=", value)
        end
      end

      expect(described_class.configuration).to have_attributes(configuration)
    end

    it 'has some default values' do
      described_class.configure do |config|
        configuration.each do |key, value|
          config.public_send("#{key}=", value)
        end
      end

      config_keys_with_default_value.each do |key|
        expect(described_class.configuration.public_send(key)).not_to be_nil
      end
    end

    it 'raises configuration error if credentials are missing' do
      expect {
        described_class.configure
      }.to raise_error(GoogleLogger::InvalidConfigurationError)
    end

    it 'does not raise configuration error if credentials are missing but log_locally is true' do
      expect {
        described_class.configure do |config|
          config.log_locally = true
          config.local_logger = Logger.new(STDOUT)
        end
      }.not_to raise_error
    end

    it 'raises configuration error if log_locally is true and local_logger is missing' do
      expect {
        described_class.configure do |config|
          config.log_locally = true
        end
      }.to raise_error(GoogleLogger::InvalidConfigurationError)
    end

    it 'raises configuration error if local_logger does not respond to logging levels' do
      expect {
        described_class.configure do |config|
          config.log_locally = true
          config.local_logger = Object.new
        end
      }.to raise_error(GoogleLogger::InvalidConfigurationError)
    end
  end

  context 'when creating entries' do
    before :each do
      configure_google_logger
    end

    it 'creates an entry' do
      result = described_class.create_entry('payload', log_name: 'log_name', severity: :INFO)

      expect(result).to be true
    end

    it 'logs an exception' do
      exception = StandardError.new('testing exception logging')
      result = described_class.log_exception(exception)

      expect(result).to be true
    end

    it 'logs a request and params' do
      request = double('request')
      allow(request).to receive(:ip) { '0.1.2.3' }
      allow(request).to receive(:original_url) { 'http://abc.def:1234/something' }
      allow(request).to receive(:method) { 'POST' }

      params = ActionController::Parameters.new({ a: 1, b: 2 })
      result = described_class.log_request(request, params)

      expect(result).to be true
    end
  end
end
