# frozen_string_literal: true
require_relative 'player'
require_relative 'dice'
require_relative 'combat_element'

module Irrgarten
  class Weapon < CombatElement
    public_class_method :new
    #def initialize(power, uses)
      #super(power, uses) #primera forma
      #super si no tiene parámetros coje los parametros del metodo

      #end si no ponemos constructor en ruby, ya que en ruby hereda el constructor del padre

    def attack
      self.produce_effect
    end

    def to_s
      "W" + super
    end

  end
end