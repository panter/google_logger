# frozen_string_literal: true

RSpec.describe GoogleLogger::JsonLogger do
  let(:logger) { described_class.new }
  let(:message) { 'log_message' }
  let(:json_message) { { key: 'value' } }
  let(:tag_name) { 'my_tag' }

  it 'logs a text message' do
    expect(GoogleLogger).to receive(:create_entry).with(message, log_name: 'default', severity: :INFO)

    logger.info(message)
  end

  it 'logs a json message' do
    expect(GoogleLogger).to receive(:create_entry).with(json_message, log_name: 'default', severity: :INFO)

    logger.info(json_message)
  end

  context 'when setting severity' do
    it 'creates a FATAL severity log' do
      expect(GoogleLogger).to receive(:create_entry).with(message, log_name: 'default', severity: :CRITICAL)

      logger.fatal(message)
    end

    it 'creates an ERROR severity log' do
      expect(GoogleLogger).to receive(:create_entry).with(message, log_name: 'default', severity: :ERROR)

      logger.error(message)
    end

    it 'creates a WARN severity log' do
      expect(GoogleLogger).to receive(:create_entry).with(message, log_name: 'default', severity: :WARNING)

      logger.warn(message)
    end

    it 'creates an INFO severity log' do
      expect(GoogleLogger).to receive(:create_entry).with(message, log_name: 'default', severity: :INFO)

      logger.info(message)
    end

    it 'creates a DEBUG severity log' do
      expect(GoogleLogger).to receive(:create_entry).with(message, log_name: 'default', severity: :DEBUG)

      logger.debug(message)
    end
  end

  context 'when using tags' do
    let(:logger) { ActiveSupport::TaggedLogging.new(described_class.new) }
    let(:outer_tag) { 'outer_tag' }

    it 'adds tags to the log' do
      expect(GoogleLogger).to receive(:create_entry).with(message, log_name: tag_name, severity: :INFO)

      logger.tagged(tag_name) do
        logger.info(message)
      end
    end

    it 'joins tag by "." when using multiple tags' do
      expect(GoogleLogger).to receive(:create_entry).with(
        message,
        log_name: "#{outer_tag}.#{tag_name}",
        severity: :INFO
      )

      logger.tagged(outer_tag) do
        logger.tagged(tag_name) do
          logger.info(message)
        end
      end
    end
  end
end
