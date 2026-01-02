class Product
  attr_accessor :id, :name, :description, :price

  def initialize(id:, name:, description:, price:)
    @id = id
    @name = name
    @description = description
    @price = price
  end

  def self.list
    [
      Product.new(
        id: 1,
        name: "Wireless Mouse",
        description: "A smooth and responsive wireless mouse.",
        price: 29.99
      ),
      Product.new(
        id: 2,
        name: "Mechanical Keyboard",
        description: "A durable mechanical keyboard with customizable keys.",
        price: 89.99
      ),
      Product.new(
        id: 3,
        name: "HD Monitor",
        description: "A 24-inch HD monitor with vibrant colors.",
        price: 149.99
      ),
      Product.new(
        id: 4,
        name: "USB-C Hub",
        description: "A versatile USB-C hub with multiple ports.",
        price: 49.99
      )
    ]
  end
end
