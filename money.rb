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
		assert Franc.new(5).equals(Franc.new(5))
		refute Franc.new(5).equals(Franc.new(6))
		refute Franc.new(5).equals(Dollar.new(5))
	end

	def test_#==
	  assert Dollar.new(5) == (Dollar.new(5))
	  refute Dollar.new(5) == (Dollar.new(6))
	end

	def test_franc_multiplication
		five = Franc.new(5)
		assert_equal Franc.new(10), five.times(2)
		assert_equal Franc.new(15), five.times(3)
	end
end

class Money
	attr_reader :amount

	def initialize(amount)
		@amount = amount
	end
	
	def ==(object)
		@amount == object.amount and self.class.name == object.class.name
	end
	alias :equals :==
end

class Dollar < Money
	def times(multiplier)
		Dollar.new(@amount*multiplier)
	end
end

class Franc < Money
	def times(multiplier)
		Franc.new(@amount*multiplier)
	end
end
