# Letsurvey

Survey creation and management app with payment integration for subscription plans.

## Technical stack

- **Backend:** Ruby on Rails 8
- **Ruby:** 3.3.5
- **Database:** SQLite 3
- **Frontend:** Tailwind CSS, Hotwire (Turbo + Stimulus), Importmap (ESM)
- **Auth:** Session + bcrypt (has_secure_password)
- **Payments:** ZaloPay (create order, IPN callback, return URL, query order status)
- **Unit test:**: Rspec 

## Setup

### Requirements

- Ruby 3.3.5 (rbenv or rvm recommended)
- Node.js (for Tailwind/asset build)

### Installation

```bash
# Clone repo
git clone <repo-url>
cd letsurvey

# Install gems
bundle install

# Create DB and run migrations
bin/rails db:create db:migrate

# (Optional) Seed sample data
bin/rails db:seed

# Build assets (Tailwind)
bin/rails tailwindcss:build
# Or watch during development:
# bin/rails tailwindcss:watch
```

### Run the app

```bash
bin/rails server
```

Open: http://localhost:3000

### ZaloPay configuration (for payments)

- Copy or edit `config/initializers/zalopay.rb` (or use environment variables) with `APP_ID`, `KEY1`, `KEY2`, and endpoint (sandbox/production).

## Main features

- **Account:** Sign up, sign in, password reset, profile edit.
- **Widgets (surveys):** Create/edit/delete widgets, add questions, preview, view analytics.
- **Public form:** Survey form by slug (`/forms/:slug`), submit responses, thank-you page.
- **Subscription:** View plans (Free, Regular, Premium), choose plan and payment method (ZaloPay App, ATM, international card, ZaloPay wallet).
- **ZaloPay payments:** Create order, IPN callback, return URL redirect, query order status.
- **Analytics:** Overview analytics and per-widget analytics.
