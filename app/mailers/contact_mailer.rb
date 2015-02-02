class ContactMailer < ActionMailer::Base
  default :from => "<no-reply@mokio.org>"
  def msg(obj, recipients)
    @message = obj.template
    @message.gsub!("%name%", obj.name)
    @message.gsub!("%email%", obj.email)
    @message.gsub!("%content%", obj.message)
    @message.gsub!("%title%", obj.title)

    mail(to: recipients, subject: "#{obj.title}")
  end
  
end