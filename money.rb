require 'minitest/autorun'
require 'purdytest'

class MoneyTest < MiniTest::Unit::TestCase 
	def	test_multiplication
		five = Money.dollar(5)
		assert_equal Money.dollar(10), five.times(2)
		assert_equal Money.dollar(15), five.times(3)
	end

	def test_equality
		assert Money.dollar(5).equals(Money.dollar(5))
		refute Money.dollar(5).equals(Money.dollar(6))
		assert Money.franc(5).equals(Money.franc(5))
		refute Money.franc(5).equals(Money.franc(6))
		refute Money.franc(5).equals(Money.dollar(5))
	end

	def test_#==
	  assert Money.dollar(5) == (Money.dollar(5))
	  refute Money.dollar(5) == (Money.dollar(6))
	end

	def test_franc_multiplication
		five = Money.franc(5)
		assert_equal Money.franc(10), five.times(2)
		assert_equal Money.franc(15), five.times(3)
	end
end

class Money
	attr_reader :amount

	def initialize(amount)
		@amount = amount
	end

	def self.dollar(amount)
		Dollar.new(amount)
	end

	def self.franc(amount)
		Franc.new(amount)
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
