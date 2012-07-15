cols = 2
rows = 5

card_width = (pdf.bounds.right-pdf.bounds.left)/cols
card_height = (pdf.bounds.top-pdf.bounds.bottom)/rows
cards_per_page = rows*cols
card_number = 0
col_number = 0
row_number = 0

@codes.each do |code|

  # If we're over the max number of columns
  if col_number >= cols
    # Start a new row
    row_number += 1
    col_number = 0
  end
  # If we're over the max number of rows
  if row_number >= rows
    # Start a new page
    row_number = 0
    col_number = 0
    pdf.start_new_page
  end

  pdf.bounding_box [col_number*card_width, (rows-row_number)*card_height], :width => card_width, :height => card_height do |bbox|
    pdf.stroke_color "000000"
    pdf.stroke_bounds
    pdf.stroke_color "CCCCCC"
    pdf.move_down 15

    pdf.text code.role.to_s.capitalize + " card", :align => :center, :style => :bold
    pdf.text "Your registration code is:", :align => :center
    pdf.move_down 15

    pdf.stroke_horizontal_rule
    pdf.move_down 5
    pdf.text code.code, :align => :center, :color => "AAAAAA", :size => 24
    pdf.stroke_horizontal_rule
    pdf.move_down 20

    pdf.text "Register at http://membit.herokuapp.com/", :align => :center

    #printed_codes.append(code)
  end

  col_number += 1
end