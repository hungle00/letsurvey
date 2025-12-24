class ChangeAndAddColumnsInWidgets < ActiveRecord::Migration[8.0]
  def up
    change_column :widgets, :start_date, :date, default: nil
    change_column :widgets, :end_date, :date, default: nil

    add_column :widgets, :questions_count, :integer, default: 0

    # Reset counter cache for existing records
    Widget.reset_counters(Widget.all, :questions)
  end

  def down
    remove_column :widgets, :questions_count
    change_column :widgets, :start_date, :datetime, default: nil
    change_column :widgets, :end_date, :datetime, default: nil
  end
end
