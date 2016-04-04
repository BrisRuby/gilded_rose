def update_quality(items)
  items.each do |item|
    decorator = DecoratorFactory.new(item).decorator
    decorator.process
  end
end


class ItemProcessor < SimpleDelegator
  def process
    raise NotYetImplementedError
  end
end

class NotYetImplementedError < StandardError
end


class ItemEvaluator < ItemProcessor
  def step_1
    decrement_quality
  end

  def step_2
    self.sell_in -= 1
  end

  def step_3
    if expired?
      decrement_quality
    end
  end

  def process
    step_1
    step_2
    step_3
  end

  private

  def expired?
    sell_in < 0
  end

  def usable?
    quality < 0
  end

  def decrement_quality
    if usable?
      self.quality -= 1
    end
  end
end

class SulfurasEvaluator < ItemProcessor
  def process
  end
end

class PassEvaluator < ItemProcessor
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

class AgedBrieEvaluator < ItemProcessor

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
      if quality < 50
        self.quality += 1
      end
    end
  end

  def process
    step_1
    step_2
    step_3
  end
end

class ConjuredEvaluator < ItemProcessor
  def process
    decrement_quality
    self.quality = 0 if broken?
    self.sell_in -= 1
  end

  private

  def decrement_quality
    if sell_in > 0
      self.quality -= 2
    else
      self.quality -= 4
    end
  end

  def broken?
    quality <= 0
  end
end

class DecoratorFactory
  attr_reader :decorator
  ClassMaps = { 'Sulfuras, Hand of Ragnaros' => SulfurasEvaluator, 'Backstage passes to a TAFKAL80ETC concert' => PassEvaluator, 
                'Aged Brie' => AgedBrieEvaluator, 'Conjured Mana Cake' => ConjuredEvaluator }
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

