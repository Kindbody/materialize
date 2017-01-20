require 'spec_helper'

describe Materialize::Repo do

  let(:repo) { Materialize::Repo.new }

  it 'returns a collection of entities containing the data from the data source if the result is an []' do
    zombies = repo.find_all_zombies(DataSource::Zombie)
    zombie  = zombies.first
    expect(zombie.class).to eq(Entities::Zombie)
    expect(zombie.name).to eq('Bob the zombie')
    expect(zombie.id).to eq(1)
    expect(zombies.count).to eq(3)
  end


  it 'also handles the case where the argument is an array' do
    zombies = repo.find_two_zombies(DataSource::Zombie, args: [1,2])
    zombie  = zombies.last
    expect(zombie.name).to eq('Sarah the zombie')
    expect(zombie.id).to eq(2)
    expect(zombies.count).to eq(2)
  end

  it 'returns an individual entity containing the data from the data source if the result is a {}' do
    zombie = repo.find_one_zombie(DataSource::Zombie, args: 2)
    expect(zombie.class).to eq(Entities::Zombie)
    expect(zombie.name).to eq('Sarah the zombie')
    expect(zombie.id).to eq(2)
  end

end

module DataSource
  class Zombie
    class << self

      def find_all_zombies
        [{ id: 1, name: 'Bob the zombie' }, { id: 2, name: 'Sarah the zombie' }, { id: 3, name: 'Me the zombie' }]
      end

      def find_two_zombies(id_1, id_2)
        [{ id: 1, name: 'Bob the zombie' }, { id: 2, name: 'Sarah the zombie' }]
      end

      def find_one_zombie(id)
        { id: 2, name: 'Sarah the zombie' }
      end
    end
  end
end

module Entities
  class Zombie

    def self.wrap(zombies_data)
      zombies_data.map { |zombie_data| new(zombie_data)  }
    end

    attr_reader :id, :name

    def initialize(attributes)
      @id = attributes[:id]
      @name = attributes[:name]
    end

  end
end
