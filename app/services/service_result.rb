class ServiceResult
  attr_reader :status, :exception, :message, :data, :errors

  def initialize(status:, exception: nil, message: nil, data: nil, errors: [])
    @status = status
    @exception = exception
    @message = message
    @message ||= exception_message(exception) if exception.present?
    @data = data
    @errors = errors

    Rails.logger.try(@status ? :info : :error, @message) if @message
    Rails.logger.error(exception_message(exception)) if exception.present? && message.present?
    Rails.logger.info to_s
  end

  def success?
    status == true
  end

  def failure?
    !success?
  end

  def data?
    data.present?
  end

  def errors?
    errors.present? && errors.length.positive?
  end

  def to_s
    "- Service result: #{success? ? 'Success!' : 'Failure!'} - #{message} - #{data}"
  end

  private

  def exception_message(exception)
    "Error occurred - #{exception.message}\n#{exception.backtrace.join("\n")}"
  end
end
