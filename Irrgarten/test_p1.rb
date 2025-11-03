# frozen_string_literal: true
require_relative 'weapon'
require_relative 'shield'
require_relative 'directions'
require_relative 'orientation'
require_relative 'dice'
require_relative 'player'
require_relative 'monster'
require_relative 'labyrinth'
require_relative 'game'
require_relative 'game_state'
require_relative 'combat_element'
require_relative 'helmet'

module Irrgarten
  class TestP1
    def main
      #p1 = Player.new('1', 4.5, 3.3)
      #valid_moves = [Directions::RIGHT, Directions::DOWN]
      #d = p1.move(Directions::UP, valid_moves)

      #w1 = Weapon.new(10,5)
      #p1.new_weapon(w1)
      #puts "fin"
      #objeto = Dice.new
      #for i in 1..100 do
      # res = objeto.random_strength
      # puts res
      #end

      #game = Game.new(1)
      #puts game.mostrar_lab
      #lab2 = Labyrinth.new(4,5,1,2)

      #juego = Game.new(3)
      #puts juego.mostrar_lab


    end
  end
end

t = Irrgarten::TestP1.new
t.main