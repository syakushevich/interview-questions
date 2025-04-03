module CSVGenerator
  def generate(model)
    CSV.open(generate_name(model.name), "wb", write_headers: true, headers: ['id','email', 'notifications.count']) do |csv|
      model.all.includes(:notifications).each.in_batches(100_000) { |row| csv << [row.id, row.email, row.notifications_count] }
    end
  end

  def generate_name(model_name)
    "#{model_name.send(:table_name)}_#{Date.current.to_s}.csv"
  end
end

class UserDataGenerator
  def self.generate(type)
    model = type.constantize
    FileGenerator.generate(model)
  end
end

file = UserDataGenerator.generate(model)
file.file_name

class User
  self.table_name = 'super_user'
end
