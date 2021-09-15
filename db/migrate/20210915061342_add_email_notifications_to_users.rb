class AddEmailNotificationsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :notify_when_added_to_project, :boolean
    add_column :users, :notify_when_task_created, :boolean
    add_column :users, :notify_when_task_completed, :boolean
  end
end
