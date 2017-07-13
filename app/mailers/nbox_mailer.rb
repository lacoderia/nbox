class NboxMailer < ActionMailer::Base
  default from: "\"nbox\" <contacto@n-box.com.mx>", reply_to: "Geor Nbox <geor@n-box.com.mx>" 

  def welcome user, data = nil
    @user = user
    mail(to: @user.email, subject: "¡Bienvenido a Nbox!")
  end

  def booking user, appointment
    @user = user
    @appointment = appointment
    mail(to: @user.email, subject: "Tu clase ha sido reservada")
  end

  def purchase user, purchase
    @user = user
    @purchase = purchase
    @challenge = false
    if @purchase.pack.id == 6
      @challenge = true
    end
    mail(to: @user.email, subject: "Confirmación de compra")
  end

  def classes_left_reminder user, data = nil
    @user = user
    mail(to: @user.email, subject: "Tus clases están por terminarse")
  end

  def expiration_reminder user, data = nil
    @user = user
    mail(to: @user.email, subject: "Tus clases expirarán pronto")
  end

  def send_coupon user, email
    @user = user
    mail(to: email, subject: "¡#{@user.first_name} te invita a probar NBox!")
  end

  def after_first_class user, appointment
    @user = user
    @appointment = appointment
    mail(to: @user.email, subject: "¿Cómo te fue en tu primera clase?")
  end

  def shared_coupon referred, referrer 
    @referred = referred
    mail(to: referrer.email, subject: "¡Tienes saldo a favor!")
  end

end
