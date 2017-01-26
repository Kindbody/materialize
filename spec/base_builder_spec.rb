require 'spec_helper'

describe Materialize::BaseBuilder do

  it "can find the name of the relevant entity from the class name" do
    expect(OompaLoompaBuilder.entity_class).to eq(Entities::OompaLoompa)
  end

  it "can allow extra items to be added after the builder info is attached" do
    repo = double('repo')
    oompa_loompa = OompaLoompaBuilder.build({ type: 'Doo-pa-dee-doo' }, repo, {})
    expect(oompa_loompa.type).to eq('Doo-pa-dee-doo')
    expect(oompa_loompa.name).to eq('Jethro')
  end

  it "attaches a repo and options to the builder" do
    repo = double('repo')
    oompa_loompa = OompaLoompaBuilder.build({ type: 'Doo-pa-dee-doo' }, repo, {})
    expect(oompa_loompa.__send__(:__repo__)).to eq(repo)
    expect(oompa_loompa.__send__(:__options__)).to eq({})
  end

  it "correctly passes the repo and options to sub-entities" do
    repo = double('repo')
    oompa_loompa = OompaLoompaBuilder.build({
      type: 'Doo-pa-dee-doo',
      wimps: [
        {id: 1},
        {id: 2}
      ]
    }, repo, {})
    wimp = oompa_loompa.wimps.first
    expect(wimp).to be_a(Entities::Wimp)
    expect(wimp.__send__(:__repo__)).to eq(repo)
    expect(wimp.__send__(:__options__)).to eq({})
  end

end

module Entities
  class OompaLoompa < Materialize::Entity
    attr_accessor :name
  end
  class Wimp < Materialize::Entity
  end
end

class OompaLoompaBuilder < Materialize::BaseBuilder
  class << self

    def build(attributes, repo, options)
      entity = super
      entity.name = 'Jethro'
      entity
    end

  end
end

class WimpBuilder < Materialize::BaseBuilder
end
