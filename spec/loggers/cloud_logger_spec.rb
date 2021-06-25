# frozen_string_literal: true

RSpec.describe GoogleLogger::Loggers::CloudLogger do
  before :all do
    configure_google_logger
  end

  let(:payload) { { a: 1, b: '2' } }
  let(:log_name) { 'gem_test_log' }
  let(:severity) { :INFO }
  let(:entry) { described_class.new.build_entry(payload, log_name: log_name, severity: severity) }

  it 'builds a log entry with default configuration' do
    expect(entry).to be_a(Google::Cloud::Logging::Entry)
    expect(entry).to have_attributes(payload: payload, severity: severity)
    expect(entry.log_name).to match("#{log_name}$")
    expect(entry.resource.type).to eq(GoogleLogger.configuration.resource_type)
    expect(entry.resource.labels).to eq(GoogleLogger.configuration.resource_labels)
  end

  it 'writes an existing entry' do
    logger = described_class.new
    result = logger.write_entry(entry)

    expect(result).to be true
  end
end
