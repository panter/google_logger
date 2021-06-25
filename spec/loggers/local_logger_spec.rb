# frozen_string_literal: true

RSpec.describe GoogleLogger::Loggers::LocalLogger do
  let(:payload) { { a: 1, b: '2' } }
  let(:log_name) { 'gem_test_log' }
  let(:severity) { :INFO }
  let(:entry) { described_class.new.build_entry(payload, log_name: log_name, severity: severity) }

  before do
    configure_google_logger_for_local_logging
  end

  it 'builds a local log entry' do
    expect(entry).to be_a(Hash)
    expect(entry).to include(payload: payload, log_name: log_name, severity: severity)
  end

  it 'writes an existing entry' do
    logger = described_class.new
    result = logger.write_entry(entry)

    expect(result).to be true
  end
end
