# Define an abstract FilterStrategy class
class FilterStrategy
  def remove_value(val)
    raise NotImplementedError, "Subclasses must implement `remove_value`"
  end
end

# Concrete Strategy: Remove Negative Numbers
class RemoveNegativeStrategy < FilterStrategy
  def remove_value(val)
    val < 0
  end
end

# Concrete Strategy: Remove Odd Numbers
class RemoveOddStrategy < FilterStrategy
  def remove_value(val)
    val.abs % 2 == 1
  end
end

# Context class that applies the filtering strategy
class Values
  def initialize(vals)
    @vals = vals
  end

  def filter(strategy)
    @vals.reject { |n| strategy.remove_value(n) }
  end
end

# Example usage
values = Values.new([-7, -4, -1, 0, 2, 6, 9])

puts "After removing negatives: #{values.filter(RemoveNegativeStrategy.new)}"
# Output: After removing negatives: [0, 2, 6, 9]

puts "After removing odd numbers: #{values.filter(RemoveOddStrategy.new)}"
# Output: After removing odd numbers: [-4, 0, 2, 6]
