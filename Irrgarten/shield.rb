# frozen_string_literal: true
require_relative 'dice'

module Irrgarten
  class Shield < CombatElement
    public_class_method :new

    def protect
      self.produce_effect
    end

    def to_s
      "S" + super
    end

  end
end