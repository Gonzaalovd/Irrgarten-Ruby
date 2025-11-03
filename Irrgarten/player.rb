# frozen_string_literal: true
require_relative 'weapon'
require_relative 'dice'
require_relative 'directions'
module Irrgarten

  class Player < LabyrinthCharacter
    @@MAX_WEAPONS = 2
    @@MAX_SHIELDS = 3
    @@INITIAL_HEALTH = 10
    @@HITS2LOSE = 3

    def initialize(number, intelligence, strength)
      super("Player #" + number.to_s, intelligence, strength, @@INITIAL_HEALTH)
      @number = number
      @consecutive_hits = 0
      # #atributos de relaciones
      #se ponen corchetes para crear un array y hay que inicializarlo
      @weapons = []
      @shields = []
    end
    def copy(other)
      super(other)
      @weapons = other.(@weapons)
      @shields = other.(@shields)
      @consecutive_hits = other.(@consecutive_hits)
    end

    def resurrect
      @weapons.clear
      @shields.clear
      @health = @@INITIAL_HEALTH
      @consecutive_hits = 0
    end

    def number
      @number
    end

    def pos(row, col)
      super
    end

    def dead
      @health == 0
    end

    def move(direction, valid_moves)
      size = valid_moves.size
      contained = valid_moves.include?(direction)
      if (size > 0) && !contained
        first_element = valid_moves[0]
      else
        direction
      end
    end

    def attack
      sum = 0.0
      sum += @strength
      sum += self.sum_weapons
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

    def receive_reward
      n_reward = Dice.weapon_reward
      s_reward = Dice.shields_reward

      for i in 1..n_reward
        w_new = new.Weapon(Dice.weapon_power, Dice.uses_left)
        receive_weapon(w_new)
      end

      for i in 1..s_reward
        s_new = new.Shield(Dice.shield_power, Dice.uses_left)
        receive_shield(s_new)
      end

      extra_health = Dice.health_reward
      @health += extra_health
    end

    def to_s
      "P" + super
    end

    private

    def receive_weapon(w)
      for weapon in @weapons
        wi = weapon
        discard = wi.discard

        if discard
          @weapons.delete(wi)
        end
      end

      size = @weapons.size

      if size < @@MAX_WEAPONS
        @weapons << w
      end
    end

    def receive_shield(s)
      for shield in @shields
        si = shield
        discard = si.discard
        if discard
          @shields.delete(si)
        end
      end
      size = @shields.size

      if size < @@MAX_SHIELDS
        @shields << s
      end
    end

    def new_weapon
      w1 = Weapon.new(Dice.weapon_power, Dice.uses_left)
      @weapons << w1
    end

    def new_shield
      s1 = Shield.new(Dice.shield_power, Dice.uses_left)
      @shields << s1
    end

    protected
    def sum_weapons
      sum = 0.0
      if @weapons.empty?
        for weapon in @weapons
          sum += weapon.attack
        end
      end
      sum
    end

    def sum_shields
      sum = 0.0
      if @shields.empty?
        for shield in @shields
          sum += shield.protect.to_f
        end
      end
      sum
    end

    def defensive_energy
      sum = 0.0
      sum += @intelligence
      sum += self.sum_shields
    end

    private
    def manage_hit(received_attack)
      defense = self.defensive_energy

      if defense < received_attack
        got_wounded
        inc_consecutive_hits
      else
        reset_hits
      end

      if @consecutive_hits == @@HITS2LOSE || dead
        reset_hits
        lose = true
      else
        lose = false
      end

      lose
    end

    def reset_hits
      @consecutive_hits = 0
    end

    def inc_consecutive_hits
      @consecutive_hits += 1
    end

  end
end