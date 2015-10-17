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

  def test_plus_returns_sum
    five = Money.dollar(5)
    sum = five.plus(five)
    assert_equal five, sum.augend
    assert_equal five, sum.addend
  end

  def test_reduce_sum
    sum = Sum.new(Money.dollar(3),Money.dollar(4))
    bank = Bank.new
    result = bank.reduce(sum, 'USD')
    assert_equal Money.dollar(7), result
  end

  def test_reduce_money
    bank = Bank.new
    result = bank.reduce(Money.dollar(1), 'USD')
    assert_equal Money.dollar(1), result
  end

  def test_reduce_money_differen_currency
    bank = Bank.new
    bank.add_rate('CHF', 'USD', 2)
    result = bank.reduce(Money.franc(2), 'USD')
    assert_equal Money.dollar(1), result
  end

  def test_identity_rate
    assert_equal 1, Bank.new().rate('USD','USD')
  end

  def test_add_mixed_addition
    fiveBucks = Money.dollar(5)
    tenFrancs = Money.franc(10)
    bank = Bank.new
    bank.add_rate('CHF', 'USD', 2)
    result = bank.reduce(fiveBucks.plus(tenFrancs), 'USD')
    assert_equal Money.dollar(10), result
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

	def +(addend)
    Sum.new(self, addend)
	end
	alias :plus :+

  def reduce(bank, to)
    rate = bank.rate(@currency, to)
    Money.new(@amount/rate, to)
  end
end

class Bank

  def initialize
    @rates = {}
  end

	def reduce(source, to)
    source.reduce(self, to)
  end

  def add_rate (from, to, rate)
    @rates[Pair.new(from, to)] = rate
  end

  def rate(from, to)
    return 1 if from == to
    @rates[Pair.new(from, to)]
  end

  class Pair
    attr_reader :from, :to

    def initialize(from, to)
      @from  = from
      @to = to
    end

    def ==(object)
      @from == object.from && @to == object.to
    end
    alias :eql? :==

    def hash
      0
    end
  end
end

class Sum
  attr_reader :augend, :addend

  def initialize(augend, addend)
    @augend = augend
    @addend = addend
  end

  def reduce(bank, to)
    amount = @augend.reduce(bank,to).amount  + @addend.reduce(bank,to).amount
    Money.new(amount,to)
  end

  def +(addend)
    nil
  end
end

