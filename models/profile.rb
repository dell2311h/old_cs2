class Profile
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  # field <name>, :type => <type>, :default => <value>
  field :name, :type => String
  embeds_many :commands

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>

  def describe
    puts "name: #{self.name}"
    puts "commands (#{self.commands.count}):"

    self.commands.asc(:ordering_number).each do |command|
      puts "  ordering_number: #{command.ordering_number}"
      puts "  job_name: #{command.job_name}"
      puts "  input_from_command_with_number: #{command.input_from_command_with_number}"
      puts "  create_media: #{command.create_media}"
      command.options.each do |option|
        puts "\t key: #{option.key}"
        puts "\t value: #{option.value}"
        puts "\t param_key_name: #{option.params_key_name}"
      end
    end
    nil
  end
end
