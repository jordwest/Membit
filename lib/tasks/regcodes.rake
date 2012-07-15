namespace :regcodes do
  desc "Generate sheets of cutout cards for all the registration codes in the database"
  task :generatecards => :environment do

    # Config
    rows = 5
    cols = 2

    timestamp = Time.now.strftime "%Y_%m_%d_%H%M%S"

    unprinted_codes = RegistrationCode.find_unprinted
    printed_codes = []

    if unprinted_codes.count < 1
      puts "No cards to print"
      return
    else
      puts "Printing " + unprinted_codes.count.to_s + " cards..."
    end

    Prawn::Document.generate "codecards_" + timestamp + ".pdf" do |pdf|

    end

    # If everything went well, mark the codes as printed
    printed_codes.each do |code|
      code.printed = 1
      code.save
    end

    puts "Done."
  end
end
