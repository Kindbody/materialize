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

  it 'can handle arguments in concurrent mode' do
    zombie = repo.find_one_zombie(DataSource::ConcurrentZombie, args: 2)
    expect(zombie.class).to eq(Entities::ConcurrentZombie)
    expect(zombie.name).to eq('Sarah the zombie')
    expect(zombie.id).to eq(2)
    expect(zombie.brains.count).to eq(3)
  end

  it 'handles the case where a token is needed' do
    repo = Materialize::Repo.new('token-12345')
    zombie = repo.find_one_zombie_with_token(DataSource::Zombie, args: 2)
    expect(zombie.class).to eq(Entities::Zombie)
    expect(zombie.name).to eq('Locked up zombie')
    expect(zombie.id).to eq(4)
  end

  it 'creates the builder class on the fly if it does not exist' do
    repo = Materialize::Repo.new('token-12345')
    zombie = repo.find_one_zombie_with_token(DataSource::Zombie, args: 2)
    expect(zombie.class).to eq(Entities::Zombie)
    expect(zombie.name).to eq('Locked up zombie')
    expect(zombie.id).to eq(4)
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

      def find_one_zombie_with_token(token, id)
        { id: 4, name: 'Locked up zombie' }
      end
    end
  end
end

module Entities
  class Zombie < Materialize::Entity
  end
end

# Testing concurrency

module DataSource
  class ConcurrentZombie
    class << self

      def find_one_zombie(id)
        { id: 2, name: 'Sarah the zombie' }
      end

    end
  end

  class Brain
    class << self

      def find_brains_for(zombie)
        [{id: 1}, {id: 2}, {id: 3}]
      end

    end
  end
end

class ConcurrentZombieBuilder < Materialize::BaseBuilder
  class << self

    def build(data, options)
      zombie = Entities::ConcurrentZombie.new(data)
      concurrent -> do
        zombie.brains = options[:repo].find_brains_for(DataSource::Brain, args: zombie)
      end
      zombie
    end

  end
end

module Entities
  class ConcurrentZombie < Materialize::Entity
    attr_accessor :brains
  end

  class Brain < Materialize::Entity; end
end
