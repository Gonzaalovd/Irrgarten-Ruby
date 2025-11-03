# frozen_string_literal: true
require_relative 'dice'
module Irrgarten
  class Monster < LabyrinthCharacter
    @@INITIAL_HEALTH = 5

    def initialize(name, intelligence, strength)
      super(name, intelligence, strength, @@INITIAL_HEALTH)
    end


    def attack
      Dice.intensity(@strength)
    end

    def defend(received_attack)
      is_dead = self.dead
      if !is_dead
        defensive_energy = Dice.intensity(@intelligence)
        if defensive_energy < received_attack
          self.got_wounded
          is_dead = self.dead
        end
      end
      is_dead
    end

    def to_s
      "M" + super
    end

  end
end