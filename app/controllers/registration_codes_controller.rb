class RegistrationCodesController < ApplicationController
  def index
    case
    when params[:filter] == 'unprinted'
      @codes = RegistrationCode.unprinted
    else
      @codes = RegistrationCode
    end

    if params[:tag].is_a?(String)
      @codes = @codes.find_all_by_tag(params[:tag])
    else
      @codes = @codes.all
    end

    @tag_list = RegistrationCode.group("tag")

    @record_count = @codes.count

    @roles_count = Hash.new
    @codes.each do |code|
      @roles_count[code.role.to_s] ||= 0
      @roles_count[code.role.to_s] += 1
    end
  end

  def new
    @roles = Role.all
  end

  def create
    role_to_generate = params[:role]
    number_to_generate = params[:count].to_i

    number_to_generate.times do
      new_code = RegistrationCode.generate(role_to_generate)
      new_code.tag = params[:tag]
      new_code.save
    end

    redirect_to '/registration_codes'
  end

  def print
    prawnto :filename => 'Registration_Codes.pdf'

    if params[:codes].is_a?(Array)
      @codes = RegistrationCode.find(params[:codes])
    else
      @codes = RegistrationCode.find_unprinted
    end

    # Mark the printed code as having been printed?
    if params[:mark_as_printed] == "1"
      @codes.each do |code|
        code.printed = true
        code.save
      end
    end
  end
end
