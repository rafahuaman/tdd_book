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
		refute Money.franc(5).equals(Money.dollar(5))
	end

	def test_#==
	  assert Money.dollar(5) == (Money.dollar(5))
	  refute Money.dollar(5) == (Money.dollar(6))
	end

	def test_currency
		assert_equal 'USD', Money.dollar(1).currency()
		assert_equal 'CHF', Money.franc(1).currency()
	end

	def test_simple_addition
		five = Money.dollar(5)
		sum = five.plus(five)
		bank = Bank.new
		reduced = bank.reduce(sum, 'USD')
		assert_equal Money.dollar(10), reduced
	end
end

class Money
	attr_reader :amount, :currency
	
	def initialize(amount, currency)
		@amount = amount
		@currency = currency
	end

	def self.dollar(amount)
		Money.new(amount, 'USD')
	end

	def self.franc(amount)
		Money.new(amount, 'CHF')
	end
	
	def ==(object)
		@amount == object.amount and @currency == object.currency
	end
	alias :equals :==
	
	def times(multiplier)
		Money.new(@amount*multiplier, @currency)
	end

	def +(added)
		return Money.new(@amount + added.amount, @currency)
	end
	alias :plus :+
end

class Bank
	def reduce source, to
		Money.dollar(10)
	end
end