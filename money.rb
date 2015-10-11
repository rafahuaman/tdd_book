require 'minitest/autorun'
require 'purdytest'

class MoneyTest < MiniTest::Unit::TestCase 
	def	test_multiplication
		five = Dollar.new(5)
		assert_equal Dollar.new(10), five.times(2)
		assert_equal Dollar.new(15), five.times(3)
	end

	def test_equality
		assert Dollar.new(5).equals(Dollar.new(5))
		refute Dollar.new(5).equals(Dollar.new(6))
	end

	def test_#==
	  assert Dollar.new(5) == (Dollar.new(5))
	  refute Dollar.new(5) == (Dollar.new(6))
	end
end


class Dollar
	attr_reader :amount

	def initialize(amount)
		@amount = amount
	end

	def times(multiplier)
		Dollar.new(@amount*multiplier)
	end

	def ==(object)
		@amount == object.amount
	end
	alias :equals :==
end
