require "membrane/errors"
require "membrane/schemas/base"

module Membrane
  module Schema
  end
end

class Membrane::Schemas::Regexp < Membrane::Schemas::Base
  attr_reader :regexp

  def initialize(regexp)
    @regexp = regexp
  end

  def validate(object)
    StringValidator.new(object).validate
    MatchValidator.new(@regexp, object).validate

    nil
  end

  class StringValidator

    def initialize(object)
      @object = object
    end

    def validate
      fail! if !@object.kind_of?(String)
    end

    private

    def fail!
      emsg = "Expected instance of String, given instance of #{@object.class}"
      raise Membrane::SchemaValidationError.new(emsg)
    end

  end

  class MatchValidator

    def initialize(regexp, object)
      @regexp = regexp
      @object = object
    end

    def validate
      fail! if !@regexp.match(@object)
    end

    private

    def fail!
      emsg = "Value #{@object} doesn't match regexp #{@regexp}"
      raise Membrane::SchemaValidationError.new(emsg)
    end
  end
end
