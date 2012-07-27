class FixUserWordDefaults < ActiveRecord::Migration
  def up
    puts "puts working"
    UserWord.all.each do |_uw|
      uw = UserWord.find(_uw.id)
      puts(uw.to_s + "\n\n")
      uw.save
    end
  end

  def down
  end
end
