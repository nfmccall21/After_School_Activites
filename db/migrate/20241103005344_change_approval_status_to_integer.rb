class ChangeApprovalStatusToInteger < ActiveRecord::Migration[7.2]
  def change
    change_column :activities, :approval_status, :integer
  end
end
