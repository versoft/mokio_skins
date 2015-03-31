class Frontend::ContactsController < Frontend::BaseController

  before_action :set_skin,       :only => [:mail]
  before_action :set_skin_files, :only => [:mail]
  before_action :set_mailer_from

  def set_mailer_from
    ActionMailer::Base.default :from => "no-reply@#{request.domain}"
  end

  def mail
    mailer = Mokio::Mailer.new(mailer_params)
    
    if mailer.valid?
      menu = Mokio::Menu.friendly.find("contact")
      content  = menu.contents.active.first

      mailer.template = content.contact_template.tpl

      ContactMailer.msg(mailer, content.recipient_emails).deliver
      render :file => @skin_files.contact_success.full_path
    else
      render :file => @skin_files.contact_error.full_path
    end
  end
  
  private
    def mailer_params
      params[:mailer].permit(:name, :email, :title, :message)
    end
  
end