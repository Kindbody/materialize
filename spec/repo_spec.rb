require 'spec_helper'

describe Materialize::Repo do

  it 'passes the query along to the data source' do
    repo = Materialize::Repo.new
    data_source = double('data_source')
    expect(data_source).to receive(:find_all_zombies)

    repo.find_all_zombies(data_source)
  end

end
