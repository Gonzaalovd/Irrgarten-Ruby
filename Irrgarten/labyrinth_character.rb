require_relative 'monster'
require_relative 'dice'
require_relative 'player'

module Irrgarten
  class LabyrinthCharacter
    private_class_method :new

    def initialize(name, intelligence, strength, health)
      @name = name
      @intelligence = intelligence
      @strength = strength
      @health = health
      @row = -1
      @col = -1
    end

    def copy(labyrinth_character)
      @name = labyrinth_character.(@name)
      @intelligence = labyrinth_character.(@intelligence)
      @strength = labyrinth_character.(@strength)
      @health = labyrinth_character.(@health)
      @row = labyrinth_character.(@row)
      @col = labyrinth_character.(@col)
    end

    protected
    attr_reader :name, :intelligence, :strength, :health
    attr_writer :health

    def got_wounded()
      @health -= 1
    end

    public
    attr_reader :row, :col

    def dead()
      @health == 0
    end

    def set_pos(row, col)
      @row = row
      @col = col
    end

    def to_s
      @name + "," + @intelligence.to_s + "," + @strength.to_s + "," + @health.to_s + "] \n"
    end

  end
end

