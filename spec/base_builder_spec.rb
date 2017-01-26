require 'spec_helper'

describe Materialize::BaseBuilder do

  it "can find the name of the relevant entity from the class name" do
    expect(Materialize::OompaLoompaBuilder.entity_class).to eq(Entities::OompaLoompa)
  end

  it "can allow extra items to be added after the builder info is attached" do
    repo = double('repo')
    oompa_loompa = Materialize::OompaLoompaBuilder.build({ type: 'Doo-pa-dee-doo' }, repo, {})
    expect(oompa_loompa.type).to eq('Doo-pa-dee-doo')
    expect(oompa_loompa.name).to eq('Jethro')
  end

end

module Entities
  class OompaLoompa < Materialize::Entity
    attr_accessor :name
  end
end

module Materialize
  class OompaLoompaBuilder < BaseBuilder
    class << self

      def build(attributes, repo, options)
        entity = super
        entity.name = 'Jethro'
        entity
      end

    end
  end
end
