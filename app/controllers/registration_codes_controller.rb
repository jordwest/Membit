class RegistrationCodesController < ApplicationController
  def index
    authorize! :manage, RegistrationCode

    prawnto :filename => 'Registration_Codes.pdf'

    case
    when params[:filter] == 'unprinted'
      @codes = RegistrationCode.unprinted
    else
      @codes = RegistrationCode
    end

    @codes = @codes.order("id ASC")

    if params[:tag].is_a?(String) and params[:tag] != ''
      @codes = @codes.find_all_by_tag(params[:tag])
    else
      @codes = @codes.all
    end

    @tag_list = RegistrationCode.select("tag").group("tag")

    # Count the records
    @record_count = @codes.count
    @roles_count = Hash.new
    @codes.each do |code|
      @roles_count[code.role.to_s] ||= 0
      @roles_count[code.role.to_s] += 1
    end

    # Mark the printed code as having been printed?
    if params[:format] == "pdf"
      @codes.each do |code|
        code.printed = true
        code.save
      end
    end
  end

  def new
    authorize! :manage, RegistrationCode
    @roles = Role.all
  end

  def create
    authorize! :manage, RegistrationCode

    role_to_generate = params[:role]
    number_to_generate = params[:count].to_i

    number_to_generate.times do
      new_code = RegistrationCode.generate(role_to_generate)
      new_code.tag = params[:tag]
      new_code.save
    end

    redirect_to '/registration_codes'
  end

  def mark
    authorize! :manage, RegistrationCode

    # Expects JSON, eg:
    # {action: 'tag', tag: 'new tag name', codes: [1,2,3,4]}
    @codes = RegistrationCode.find(params[:codes])

    new_tag_name = params[:tag]

    @codes.each do |code|
      case params[:mark]
        when 'tag'
          code.tag = new_tag_name
        when 'printed'
          code.printed = true
        when 'unprinted'
          code.printed = false
      end
      code.save
    end

    #redirect_to '/registration_codes'
    render :nothing => true
  end
end
