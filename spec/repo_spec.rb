require 'spec_helper'

describe Materialize::Repo do

  it 'passes the query along to the data source' do
    repo = Materialize::Repo.new
    data_source = double('data_source')
    bob = { id: 1, name: 'Bob the zombie' }
    expect(data_source).to receive(:find_all_zombies).and_return([bob])

    repo.find_all_zombies(data_source)
  end

end
