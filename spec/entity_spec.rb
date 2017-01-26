require 'spec_helper'

describe Materialize::Entity do
  let(:entity) { Materialize::Entity }

  it 'converts top level hash keys into method names' do
    e1 = entity.new({ bob: 'howdy', jill: 'noisy' })
    expect(e1.bob).to eq('howdy')
    expect(e1.jill).to eq('noisy')
  end

  it 'converts top level collections to entities using their builder if the entity exists' do
    e = entity.new({ lawn_mowers: [{ id: 'briggs' }, { id: 'kubota' }] })
    expect(e.lawn_mowers.first).to be_a(Entities::LawnMower)
  end

  it 'does not convert top level collections to entities if the entity does not exist' do
    e = entity.new({ not_lawn_mowers: [{ id: 'briggs' }, { id: 'kubota' }] })
    expect(e.not_lawn_mowers.first).to be_a(Hash)
  end
end

module Entities
  class LawnMower < Materialize::Entity

  end
end

class LawnMowerBuilder < Materialize::BaseBuilder

end
