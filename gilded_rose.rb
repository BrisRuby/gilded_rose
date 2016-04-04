def update_quality(items)
  items.each do |item|
    decorator = DecoratorFactory.new(item).decorator
    decorator.process
  end
end


class ItemEvaluator < SimpleDelegator
  def step_1
    if name != 'Aged Brie'
      if quality > 0
        self.quality -= 1
      end
    else
      if quality < 50
        self.quality += 1
      end
    end
  end

  def step_2
    self.sell_in -= 1
  end

  def step_3
    if sell_in < 0
      if name != 'Aged Brie'
        if name != 'Backstage passes to a TAFKAL80ETC concert'
          if quality > 0
            self.quality -= 1
          end
        end
      else
        if quality < 50
          self.quality += 1
        end
      end
    end
  end

  def process
    step_1
    step_2
    step_3
  end
end

class SulfurasEvaluator < SimpleDelegator
  def process
  end
end

class PassEvaluator < SimpleDelegator
  def step_1
    if quality < 50
      self.quality += 1
      if sell_in < 11
        self.quality += 1
      end
      if sell_in < 6
        self.quality += 1
      end
    end
  end

  def step_2
    self.sell_in -= 1
  end

  def step_3
    if sell_in < 0
      self.quality = quality - quality
    end
  end

  def process
    step_1
    step_2
    step_3
  end
end

class AgedBrieEvaluator < SimpleDelegator

  def step_1
    if quality < 50
      self.quality += 1
    end
  end

  def step_2
    self.sell_in -= 1
  end

  def step_3
    if sell_in < 0
      if name != 'Aged Brie'
        if name != 'Backstage passes to a TAFKAL80ETC concert'
          if quality > 0
            self.quality -= 1
          end
        end
      else
        if quality < 50
          self.quality += 1
        end
      end
    end
  end

  def process
    step_1
    step_2
    step_3
  end
end

class DecoratorFactory
  attr_reader :decorator
  ClassMaps = { 'Sulfuras, Hand of Ragnaros' => SulfurasEvaluator, 'Backstage passes to a TAFKAL80ETC concert' => PassEvaluator, 'Aged Brie' => AgedBrieEvaluator }
  def initialize(item)

    decorator_class = ClassMaps[item.name] || ItemEvaluator
    @decorator = decorator_class.new(item)
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

