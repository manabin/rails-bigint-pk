class ChangeKeysToBigint < ActiveRecord::Migration
  def change
    Rails.application.eager_load!
    ActiveRecord::Base.subclasses.each do |type|
      BigintPk.update_primary_key type.table_name, type.primary_key

      type.reflect_on_all_associations.select do |association|
        association.macro == :belongs_to
      end.each do |belongs_to_association|
        BigintPk.update_foreign_key type.table_name, belongs_to_association.foreign_key
      end
    end
  end
end