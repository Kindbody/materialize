require 'benchmark'
require 'open-uri'
require_relative "./../lib/materialize/base_builder"

module Materialize
  class RunnerBuilder < BaseBuilder
    class << self

      def sequential
        xkcds = {}
        xkcds[:xkcd501] = open('http://xkcd.com/501').read
        xkcds[:xkcd502] = open('http://xkcd.com/502').read
        xkcds[:xkcd503] = open('http://xkcd.com/503').read
        xkcds[:xkcd504] = open('http://xkcd.com/504').read
        xkcds[:xkcd505] = open('http://xkcd.com/505').read
        xkcds[:xkcd506] = open('http://xkcd.com/506').read
        xkcds[:xkcd507] = open('http://xkcd.com/507').read
        xkcds[:xkcd508] = open('http://xkcd.com/508').read
        xkcds[:xkcd509] = open('http://xkcd.com/509').read
        xkcds[:xkcd5010] = open('http://xkcd.com/510').read
        xkcds[:xkcd5011] = open('http://xkcd.com/511').read
        xkcds[:xkcd5012] = open('http://xkcd.com/512').read
        xkcds[:xkcd5013] = open('http://xkcd.com/513').read
        xkcds[:xkcd5014] = open('http://xkcd.com/514').read
        xkcds[:xkcd5015] = open('http://xkcd.com/515').read
        xkcds[:xkcd5016] = open('http://xkcd.com/516').read
        xkcds
      end

      def simultaneous
        xkcds = {}

        concurrent -> do
          xkcds[:xkcd501] = open('http://xkcd.com/501').read
        end, -> do
          xkcds[:xkcd502] = open('http://xkcd.com/502').read
        end, -> do
          xkcds[:xkcd503] = open('http://xkcd.com/503').read
        end, -> do
          xkcds[:xkcd504] = open('http://xkcd.com/504').read
        end, -> do
          xkcds[:xkcd505] = open('http://xkcd.com/505').read
        end, -> do
          xkcds[:xkcd506] = open('http://xkcd.com/506').read
        end, -> do
          xkcds[:xkcd507] = open('http://xkcd.com/507').read
        end, -> do
          xkcds[:xkcd508] = open('http://xkcd.com/508').read
        end, -> do
          xkcds[:xkcd509] = open('http://xkcd.com/509').read
        end, -> do
          xkcds[:xkcd5010] = open('http://xkcd.com/510').read
        end, -> do
          xkcds[:xkcd5011] = open('http://xkcd.com/511').read
        end, -> do
          xkcds[:xkcd5012] = open('http://xkcd.com/512').read
        end, -> do
          xkcds[:xkcd5013] = open('http://xkcd.com/513').read
        end, -> do
          xkcds[:xkcd5014] = open('http://xkcd.com/514').read
        end, -> do
          xkcds[:xkcd5015] = open('http://xkcd.com/515').read
        end, -> do
          xkcds[:xkcd5016] = open('http://xkcd.com/516').read
        end

        xkcds
      end
    end

  end
end


Benchmark.bm do |bm|
  bm.report "Sequential IO\n" do
    Materialize::RunnerBuilder.sequential
  end
end

puts '======================================================'

Benchmark.bm do |bm|
  bm.report "Concurrent IO\n" do
    Materialize::RunnerBuilder.simultaneous
  end
end
