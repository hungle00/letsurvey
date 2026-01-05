# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Seed Plans
if Plan.count == 0
  plans_data = [
    {
      name: "Free",
      max_widgets: 3,
      monthly_price: 0.0
    },
    {
      name: "Regular",
      max_widgets: 10,
      monthly_price: 9.0
    },
    {
      name: "Premium",
      max_widgets: nil, # unlimited
      monthly_price: 29.0
    }
  ]

  plans_data.each do |plan_attrs|
    Plan.find_or_create_by!(name: plan_attrs[:name]) do |plan|
      plan.max_widgets = plan_attrs[:max_widgets]
      plan.monthly_price = plan_attrs[:monthly_price]
    end
  end

  puts "✓ Seeded #{Plan.count} plans: #{Plan.pluck(:name).join(', ')}"
end

# Seed Products (for development/testing)
# Create products for the first user with subscription, or create a demo user
if Product.count == 0
  # Find or create a demo user with subscription
  demo_user = User.first
  return if demo_user.nil? || demo_user.subscription.nil?
  # Seed 5 products using Faker
  if demo_user.subscription.products.count < 5
    statuses = [ "active", "active", "active", "inactive", "active" ] # Mostly active

    5.times do |i|
      demo_user.subscription.products.create!(
        name: Faker::Commerce.product_name,
        description: Faker::Lorem.paragraph(sentence_count: 2),
        price: Faker::Commerce.price(range: 10.0..500.0),
        status: statuses[i] || "active"
      )
    end

    puts "✓ Seeded 5 products for demo user"
  else
    puts "✓ Products already exist for demo user"
  end
end
