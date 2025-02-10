# Product class
class Burger
  def initialize(ingredients)
    @ingredients = ingredients
  end

  def print
    puts @ingredients.inspect
  end
end

# Factory class
class BurgerFactory
  def create_cheese_burger
    ingredients = ["bun", "cheese", "beef-patty"]
    Burger.new(ingredients)
  end

  def create_deluxe_cheese_burger
    ingredients = ["bun", "tomato", "lettuce", "cheese"]
    Burger.new(ingredients)
  end

  def create_vegan_burger
    ingredients = ["bun", "special-sauce", "veggie-patty"]
    Burger.new(ingredients)
  end
end

# Client code
burger_factory = BurgerFactory.new

burger_factory.create_cheese_burger.print
# Output: ["bun", "cheese", "beef-patty"]

burger_factory.create_deluxe_cheese_burger.print
# Output: ["bun", "tomato", "lettuce", "cheese"]

burger_factory.create_vegan_burger.print
# Output: ["bun", "special-sauce", "veggie-patty"]
