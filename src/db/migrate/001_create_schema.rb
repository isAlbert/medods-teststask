class CreateSchema < ActiveRecord::Migration[7.0]
  def change

    create_table :patients, id: :uuid do |t|
      t.string :first_name, null: false, limit: 50
      t.string :last_name, null: false, limit: 50
      t.string :middle_name, limit: 50
      t.date :birthday, null: false
      t.string :gender, null: false, limit: 10
      t.integer :height, null: false
      t.decimal :weight, precision: 5, scale: 2, null: false
      t.timestamps
    end

    create_table :doctors, id: :uuid do |t|
      t.string :first_name, null: false, limit: 50, comment: 'Имя'
      t.string :last_name, null: false, limit: 50, comment: 'Фамилия'
      t.string :middle_name, limit: 50, comment: 'Отчество (опционально)'
      t.timestamps
    end

    create_table :patient_doctors, id: false do |t|
      t.references :patient, null: false, foreign_key: true, type: :uuid
      t.references :doctor, null: false, foreign_key: true, type: :uuid
    end

    create_table :bmr_calculations, id: :uuid do |t|
      t.references :patient, null: false, foreign_key: true, type: :uuid
      t.string :formula, null: false, limit: 20
      t.decimal :result, precision: 8, scale: 2, null: false
      t.timestamps
    end

    add_check_constraint :patients, "gender IN ('male', 'female')", name: 'patients_gender_check'
    add_check_constraint :patients, "height BETWEEN 30 AND 300", name: 'patients_height_check'
    add_check_constraint :patients, "weight BETWEEN 10 AND 500", name: 'patients_weight_check'
    add_check_constraint :bmr_calculations, "formula IN ('mifflin', 'harris')", name: 'bmr_formula_check'
    add_check_constraint :bmr_calculations, "result BETWEEN 500 AND 5000", name: 'bmr_result_check'
  end
end
