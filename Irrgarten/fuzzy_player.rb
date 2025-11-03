require_relative 'dice'

module Irrgarten
  class FuzzyPlayer < Player

    def initialize(player)
      self.copy(player)
    end

    def move(direction, valid_moves)
      dir = super
      rand = Dice.new()
      rand.next_step(dir, valid_moves, @intelligence)
    end

    def attack
      sum = 0
      sum += self.sum_weapons
      rand = Dice.new()
      sum += rand.intensity(@intelligence)
    end

    protected
    def defensive_energy
      super
    end

    public

    def to_s
      "Fuzzy" + super
    end

  end
end

