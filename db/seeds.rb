# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Seed Plans
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
