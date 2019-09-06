require 'test_helper'

module Sidekiq
  module Enqueuer
    module Model
      describe Param do
        include Rack::Test::Methods

        describe 'Param#check_params' do
          it 'parse to posible datatype' do
            params = []
            (1..5).each do |i|
              label = (i == 3 ? :opt : :req)
              params << Param.new("params#{i}", label)
            end
            result = Param.check_params({'params1' => 'abc', 'params2' => '1', 'params3' => 'nil', 'params4' => 'true', 'params5' => 'false'}, params)
            assert_equal 'abc', result[0]
            assert_equal 1    , result[1]
            assert_equal nil  , result[2]
            assert_equal true , result[3]
            assert_equal false, result[4]
          end
        end

      end
    end
  end
end
