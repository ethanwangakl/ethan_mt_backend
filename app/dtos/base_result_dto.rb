class BaseResultDto
  attr_accessor :success, :message, :data

  def self.success(message = nil, data = nil)
    result = new
    result.message = message
    result.success = true
    result.data = data
    result
  end

  def self.failed(message, data = nil)
    result = new
    result.message = message
    result.success = false
    result.data = data
    result
  end
end
