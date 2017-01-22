require 'spec_helper'

describe Materialize::BaseBuilder do

  it "can finds the name of the relevant entity from the class name" do
    expect(Materialize::OompaLoompaBuilder.entity_class).to eq(Entities::OompaLoompa)
  end

end

module Entities
  class OompaLoompa
  end
end

module Materialize
  class OompaLoompaBuilder < BaseBuilder
  end
end
