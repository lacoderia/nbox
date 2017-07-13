# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Users
user = User.create(first_name: "Arnulfo", last_name: "Quimare", email: "usuario_prueba@email.com", classes_left: 2, last_class_purchased: Time.now, picture: "url", uid: "XID3423423", password: "cantbeblank", phone: "55456792")

#Roles
role_instructor = Role.create(name: 'instructor')
role_super_admin = Role.create(name: 'super_admin')
role_front_desk = Role.create(name: 'front_desk')
role_niumedia = Role.create(name: 'niumedia')

#Instructors

#Ale
instructor_ale = Instructor.create(first_name: "Ale", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/ale.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/ale.png", bio: "", quote: "Train with style!")
AdminUser.create!(email: 'ale@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_ale)

instructor_samuel = Instructor.create(first_name: "Samuel", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/tucan.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/tucan.png", bio: "", quote: "Pain is temporary, pride is forever.")
AdminUser.create!(email: 'samuel@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_samuel)

instructor_maca = Instructor.create(first_name: "Maca", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/macarena.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/macarena.png", bio: "", quote: "Por siempre se compone de ahoras.")
AdminUser.create!(email: 'maca@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_maca)

instructor_isa = Instructor.create(first_name: "Isa", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/isa.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/isa.png", bio: "", quote: "Deja que la música te haga volar!")
AdminUser.create!(email: 'isa@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_isa)

instructor_geor = Instructor.create(first_name: "Geor", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/geor.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/geor.png", bio: "", quote: "Sé siempre la mejor versión de ti mismo.")
AdminUser.create!(email: 'geor@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_geor)

instructor_miguel = Instructor.create(first_name: "Miguel", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/miguel.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/miguel.png", bio: "", quote: "Sé el cambio que deseas ver en el mundo.")
AdminUser.create!(email: 'miguel@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_miguel)

instructor_marilu = Instructor.create(first_name: "Marilú", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/m.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/m.png", bio: "", quote: "Cambia tu cuerpo, tu mente, tu actitud y tu humor.")
AdminUser.create!(email: 'marilu@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_marilu)

instructor_diana = Instructor.create(first_name: "Diana", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/diana.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/diana.png", bio: "", quote: "Que todo fluya y que nada influya.")
AdminUser.create!(email: 'diana@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_diana)

instructor_sofi = Instructor.create(first_name: "Sofia V", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/sofiav.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/sofiav.png", bio: "", quote: "Mueve al ritmo de la música todo tu cuerpo.")
AdminUser.create!(email: 'sofi@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_sofi)

#Active Admin User
AdminUser.create!(email: 'admin@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_super_admin])

#Front desk
AdminUser.create!(email: 'info@n-bici.com', password: 'password', password_confirmation: 'password', roles: [role_front_desk])

#Niumedia
AdminUser.create!(email: 'admin@niumedia.mx', password: 'niumedia', password_confirmation: 'niumedia', roles: [role_niumedia])

#Emails
email = Email.create(user: user, email_status: "sent", email_type: "purchase")

#Packs
pack_1 = Pack.create(description: "1 clase", classes: 1, price: 140.00, special_price: 100.00, expiration: 15)
pack_2 = Pack.create(description: "5 clases", classes: 5, price: 650.00, expiration: 30)
pack_3 = Pack.create(description: "10 clases", classes: 10, price: 1200.00, expiration: 90)
pack_4 = Pack.create(description: "25 clases", classes: 25, price: 2875.00, expiration: 180)
pack_5 = Pack.create(description: "50 clases", classes: 50, price: 5000.00, expiration: 365)


#Purchases
#puchase = Purchase.create(pack: pack_1, user: user, uid: "523dd8f6aef8784386000001", object:"charge", livemode: false, status: "paid", description: "Stogies", amount: 200, currency: "MXN", payment_method: "{'object':'card_payment', 'name':'Thomas Logan', 'exp_month':'12', 'exp_year':'15'}", details: "{'name':'Arnulfo Quimare', 'phone':'403-342-0642', 'email':'logan@x-men.org'}")

#Cards
#card = Card.create(user: user, uid: "tok_test_visa_4242", object: 'card', name:'Thomas Logan', phone: '45321345', last4:'4242', exp_month:'12', exp_year:'17', active:true, address: "{'street1':'250 Alexis St', 'street2': null, 'street3': null, 'city':'Red Deer', 'state':'Alberta', 'zip':'T4N 0B8', 'country':'Canada'}", primary: true, brand: "VISA")

#Venues
venue = Venue.create(name: "Gimnasio SLP", description: "Gimnasio original")

#Bicycles
bicycle1 = Bicycle.new(position:1, number:1)
bicycle2 = Bicycle.new(position:13, number:2)
bicycle3 = Bicycle.new(position:25, number:3)
bicycle4 = Bicycle.new(position:37, number:4)
bicycle5 = Bicycle.new(position:39, number:5)
bicycle6 = Bicycle.new(position:29, number:6)
bicycle7 = Bicycle.new(position:19, number:7)
bicycle8 = Bicycle.new(position:20, number:8)
bicycle9 = Bicycle.new(position:10, number:9)
bicycle10 = Bicycle.new(position:34, number:10)
bicycle11 = Bicycle.new(position:46, number:11)
bicycle12 = Bicycle.new(position:58, number:12)
bicycle13 = Bicycle.new(position:70, number:13)
bicycle14 = Bicycle.new(position:61, number:14)
bicycle15 = Bicycle.new(position:62, number:15)
bicycle16 = Bicycle.new(position:52, number:16)
bicycle17 = Bicycle.new(position:42, number:17)
bicycle18 = Bicycle.new(position:67, number:18)
bicycle19 = Bicycle.new(position:79, number:19)

#Distributions
distribution = Distribution.create(height: 8, width: 11, description: "distribucion actual", inactive_seats: "", active_seats: Bicycle.to_string_array([bicycle1,bicycle2,bicycle3,bicycle4,bicycle5,bicycle6,bicycle7,bicycle8,bicycle9,bicycle10,bicycle11,bicycle12,bicycle13,bicycle14,bicycle15,bicycle16,bicycle17,bicycle18,bicycle19]), total_seats: 19)

#Room
room = Room.create(venue: venue, distribution: distribution, description: "Salón original")

#Schedules

monday = Time.zone.now.beginning_of_day + 3.days
tuesday = monday + 1.day 
wednesday = tuesday + 1.day
thursday = wednesday + 1.day
friday = thursday + 1.day
saturday = friday + 1.day

next_monday = monday + 7.days
next_tuesday = next_monday + 1.day 
next_wednesday = next_tuesday + 1.day
next_thursday = next_wednesday + 1.day
next_friday = next_thursday + 1.day
next_saturday = next_friday + 1.day


#Monday
Schedule.create(instructor: instructor_ale, room: room, datetime: monday + 6.hours + 15.minutes)
Schedule.create(instructor: instructor_samuel, room: room, datetime: monday + 7.hours)
Schedule.create(instructor: instructor_maca, room: room, datetime: monday + 8.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: monday + 9.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: monday + 10.hours)
Schedule.create(instructor: instructor_miguel, room: room, datetime: monday + 17.hours)
Schedule.create(instructor: instructor_marilu, room: room, datetime: monday + 18.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: monday + 19.hours)
Schedule.create(instructor: instructor_sofi, room: room, datetime: monday + 20.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: monday + 21.hours)

#Tuesday
Schedule.create(instructor: instructor_samuel, room: room, datetime: tuesday + 6.hours + 15.minutes)
Schedule.create(instructor: instructor_ale, room: room, datetime: tuesday + 7.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: tuesday + 8.hours)
Schedule.create(instructor: instructor_maca, room: room, datetime: tuesday + 9.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: tuesday + 10.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: tuesday + 17.hours)
Schedule.create(instructor: instructor_miguel, room: room, datetime: tuesday + 18.hours)
Schedule.create(instructor: instructor_sofi, room: room, datetime: tuesday + 19.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: tuesday + 20.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: tuesday + 21.hours)

#Wednesday
Schedule.create(instructor: instructor_isa, room: room, datetime: wednesday + 6.hours + 15.minutes)
Schedule.create(instructor: instructor_samuel, room: room, datetime: wednesday + 7.hours)
Schedule.create(instructor: instructor_maca, room: room, datetime: wednesday + 8.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: wednesday + 9.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: wednesday + 10.hours)
Schedule.create(instructor: instructor_miguel, room: room, datetime: wednesday + 17.hours)
Schedule.create(instructor: instructor_marilu, room: room, datetime: wednesday + 18.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: wednesday + 19.hours)
Schedule.create(instructor: instructor_sofi, room: room, datetime: wednesday + 20.hours)
Schedule.create(instructor: instructor_ale, room: room, datetime: wednesday + 21.hours)

#Thursday
Schedule.create(instructor: instructor_ale, room: room, datetime: thursday + 6.hours + 15.minutes)
Schedule.create(instructor: instructor_isa, room: room, datetime: thursday + 7.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: thursday + 8.hours)
Schedule.create(instructor: instructor_maca, room: room, datetime: thursday + 9.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: thursday + 10.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: thursday + 17.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: thursday + 18.hours)
Schedule.create(instructor: instructor_marilu, room: room, datetime: thursday + 19.hours)
Schedule.create(instructor: instructor_ale, room: room, datetime: thursday + 20.hours)
Schedule.create(instructor: instructor_miguel, room: room, datetime: thursday + 21.hours)

#Friday
Schedule.create(instructor: instructor_samuel, room: room, datetime: friday + 6.hours + 15.minutes)
Schedule.create(instructor: instructor_maca, room: room, datetime: friday + 7.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: friday + 8.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: friday + 9.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: friday + 10.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: friday + 17.hours)
Schedule.create(instructor: instructor_miguel, room: room, datetime: friday + 18.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: friday + 19.hours)

#Saturday
Schedule.create(instructor: instructor_isa, room: room, datetime: saturday + 10.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: saturday + 11.hours)
Schedule.create(instructor: instructor_ale, room: room, datetime: saturday + 12.hours)

#Next Monday
Schedule.create(instructor: instructor_ale, room: room, datetime: next_monday + 6.hours + 15.minutes)
Schedule.create(instructor: instructor_samuel, room: room, datetime: next_monday + 7.hours)
Schedule.create(instructor: instructor_maca, room: room, datetime: next_monday + 8.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_monday + 9.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_monday + 10.hours)
Schedule.create(instructor: instructor_miguel, room: room, datetime: next_monday + 17.hours)
Schedule.create(instructor: instructor_marilu, room: room, datetime: next_monday + 18.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: next_monday + 19.hours)
Schedule.create(instructor: instructor_sofi, room: room, datetime: next_monday + 20.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: next_monday + 21.hours)

#Next Tuesday
Schedule.create(instructor: instructor_samuel, room: room, datetime: next_tuesday + 6.hours + 15.minutes)
Schedule.create(instructor: instructor_ale, room: room, datetime: next_tuesday + 7.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_tuesday + 8.hours)
Schedule.create(instructor: instructor_maca, room: room, datetime: next_tuesday + 9.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_tuesday + 10.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_tuesday + 17.hours)
Schedule.create(instructor: instructor_miguel, room: room, datetime: next_tuesday + 18.hours)
Schedule.create(instructor: instructor_sofi, room: room, datetime: next_tuesday + 19.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: next_tuesday + 20.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_tuesday + 21.hours)

#Next Wednesday
Schedule.create(instructor: instructor_isa, room: room, datetime: next_wednesday + 6.hours + 15.minutes)
Schedule.create(instructor: instructor_samuel, room: room, datetime: next_wednesday + 7.hours)
Schedule.create(instructor: instructor_maca, room: room, datetime: next_wednesday + 8.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_wednesday + 9.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_wednesday + 10.hours)
Schedule.create(instructor: instructor_miguel, room: room, datetime: next_wednesday + 17.hours)
Schedule.create(instructor: instructor_marilu, room: room, datetime: next_wednesday + 18.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: next_wednesday + 19.hours)
Schedule.create(instructor: instructor_sofi, room: room, datetime: next_wednesday + 20.hours)
Schedule.create(instructor: instructor_ale, room: room, datetime: next_wednesday + 21.hours)

#Next Thursday
Schedule.create(instructor: instructor_ale, room: room, datetime: next_thursday + 6.hours + 15.minutes)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_thursday + 7.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_thursday + 8.hours)
Schedule.create(instructor: instructor_maca, room: room, datetime: next_thursday + 9.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_thursday + 10.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_thursday + 17.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: next_thursday + 18.hours)
Schedule.create(instructor: instructor_marilu, room: room, datetime: next_thursday + 19.hours)
Schedule.create(instructor: instructor_ale, room: room, datetime: next_thursday + 20.hours)
Schedule.create(instructor: instructor_miguel, room: room, datetime: next_thursday + 21.hours)

#Next Friday
Schedule.create(instructor: instructor_samuel, room: room, datetime: next_friday + 6.hours + 15.minutes)
Schedule.create(instructor: instructor_maca, room: room, datetime: next_friday + 7.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_friday + 8.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_friday + 9.hours)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_friday + 10.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_friday + 17.hours)
Schedule.create(instructor: instructor_miguel, room: room, datetime: next_friday + 18.hours)
Schedule.create(instructor: instructor_diana, room: room, datetime: next_friday + 19.hours)

#Next Saturday
Schedule.create(instructor: instructor_isa, room: room, datetime: next_saturday + 10.hours)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_saturday + 11.hours)
Schedule.create(instructor: instructor_ale, room: room, datetime: next_saturday + 12.hours)

#Appointment
#appointment = Appointment.create(user: user, schedule: schedule_1, bicycle_number: 1, status: 'BOOKED', start: schedule_1.datetime, description: "Con mi maestro favorito")

#Configuration
Config.create(key: "coupon_discount", value: "40")
Config.create(key: "referral_credit", value: "40")
