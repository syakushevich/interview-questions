# Product class
class Burger
  attr_accessor :buns, :patty, :cheese

  def initialize
    @buns = nil
    @patty = nil
    @cheese = nil
  end

  def print
    puts "Burger with: Buns = #{@buns}, Patty = #{@patty}, Cheese = #{@cheese}"
  end
end

# Builder class
class BurgerBuilder
  def initialize
    @burger = Burger.new
  end

  def add_buns(bun_style)
    @burger.buns = bun_style
    self  # Return self to allow method chaining
  end

  def add_patty(patty_style)
    @burger.patty = patty_style
    self
  end

  def add_cheese(cheese_style)
    @burger.cheese = cheese_style
    self
  end

  def build
    @burger
  end
end

# Client Code
burger = BurgerBuilder.new
  .add_buns("sesame")
  .add_patty("fish-patty")
  .add_cheese("swiss cheese")
  .build

burger.print
# Output: Burger with: Buns = sesame, Patty = fish-patty, Cheese = swiss cheese
