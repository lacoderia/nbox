# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Users
user = User.create(first_name: "Arnulfo", last_name: "Quimare", email: "usuario_prueba@email.com", classes_left: 2, picture: "url", uid: "XID3423423", password: "cantbeblank", phone: "55456792")

#Roles
role_instructor = Role.create(name: 'instructor')
role_super_admin = Role.create(name: 'super_admin')
role_front_desk = Role.create(name: 'front_desk')
role_niumedia = Role.create(name: 'niumedia')

#Instructors

#Ale
instructor_ale = Instructor.create(first_name: "Ale", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/ale.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/ale.png", bio: "", quote: "Train with style!")
AdminUser.create!(email: 'ale@n-box.com.mx', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_ale)

instructor_samuel = Instructor.create(first_name: "Samuel", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/tucan.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/tucan.png", bio: "", quote: "Pain is temporary, pride is forever.")
AdminUser.create!(email: 'samuel@n-box.com.mx', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_samuel)

instructor_maca = Instructor.create(first_name: "Maca", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/macarena.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/macarena.png", bio: "", quote: "Por siempre se compone de ahoras.")
AdminUser.create!(email: 'maca@n-box.com.mx', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_maca)

instructor_isa = Instructor.create(first_name: "Isa", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/isa.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/isa.png", bio: "", quote: "Deja que la música te haga volar!")
AdminUser.create!(email: 'isa@n-box.com.mx', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_isa)

instructor_geor = Instructor.create(first_name: "Geor", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/geor.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/geor.png", bio: "", quote: "Sé siempre la mejor versión de ti mismo.")
AdminUser.create!(email: 'geor@n-box.com.mx', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_geor)

instructor_miguel = Instructor.create(first_name: "Miguel", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/miguel.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/miguel.png", bio: "", quote: "Sé el cambio que deseas ver en el mundo.")
AdminUser.create!(email: 'miguel@n-box.com.mx', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_miguel)

instructor_marilu = Instructor.create(first_name: "Marilú", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/m.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/m.png", bio: "", quote: "Cambia tu cuerpo, tu mente, tu actitud y tu humor.")
AdminUser.create!(email: 'marilu@n-box.com.mx', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_marilu)

instructor_diana = Instructor.create(first_name: "Diana", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/diana.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/diana.png", bio: "", quote: "Que todo fluya y que nada influya.")
AdminUser.create!(email: 'diana@n-box.com.mx', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_diana)

instructor_sofi = Instructor.create(first_name: "Sofia V", last_name: "", picture: "http://www.n-bici.com/wp-content/uploads/2016/05/sofiav.png", picture_2: "http://www.n-bici.com/wp-content/uploads/2016/05/sofiav.png", bio: "", quote: "Mueve al ritmo de la música todo tu cuerpo.")
AdminUser.create!(email: 'sofi@n-box.com.mx', password: 'password', password_confirmation: 'password', roles: [role_instructor], instructor: instructor_sofi)

#Active Admin User
AdminUser.create!(email: 'admin@n-box.com.mx', password: 'password', password_confirmation: 'password', roles: [role_super_admin])

#Front desk
AdminUser.create!(email: 'info@n-box.com.mx', password: 'password', password_confirmation: 'password', roles: [role_front_desk])

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

#Stations
station1 = Station.new(position:6, number:1, description: 'Abdomen')
station2 = Station.new(position:21, number:2, description: 'Ring')
station3 = Station.new(position:24, number:3, description: 'Pera sencilla')
station4 = Station.new(position:25, number:4, description: 'Cojín cuadrado')
station5 = Station.new(position:26, number:5, description: 'Cojín cuadrado')
station6 = Station.new(position:47, number:6, description: 'Costal bola')
station7 = Station.new(position:48, number:7, description: 'Cardio')
station8 = Station.new(position:53, number:8, description: 'Costal vertical XL')
station9 = Station.new(position:71, number:9, description: 'Pera doble')
station10 = Station.new(position:74, number:10, description: 'Costal vertical')
station11 = Station.new(position:89, number:11, description: 'Costal horizontal')
station12 = Station.new(position:101, number:12, description: 'Costal vertical')
station13 = Station.new(position:112, number:13, description: 'TRX')
station14 = Station.new(position:113, number:14, description: 'TRX')

ring_string = "[{position: 11, style: 'top left'},{position: 12, style: 'top'},{position: 13, style: 'top right'},{position: 20, style: 'left'},{position: 21, style: ''},{position: 22, style: 'right'},{position: 29, style: 'bottom left'},{position: 30, style: 'bottom'}, {position: 31, style: 'bottom right'}]"

#Distributions
distribution = Distribution.create(height: 14, width: 9, description: "distribucion nbox", inactive_seats: "", active_seats: Station.to_string_array([station1,station2,station3,station4,station5,station6,station7,station8,station9,station10,station11,station12,station13,station14]), total_seats: 14, painted_seat_positions: ring_string)

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

fb = ScheduleType.create(description: "Full Body")
lb = ScheduleType.create(description: "Lower Body")
ub = ScheduleType.create(description: "Upper Body")
abs = ScheduleType.create(description: "Abs")

#Monday
Schedule.create(instructor: instructor_ale, room: room, datetime: monday + 6.hours + 15.minutes, schedule_type: fb)
Schedule.create(instructor: instructor_samuel, room: room, datetime: monday + 7.hours, schedule_type: fb)
Schedule.create(instructor: instructor_maca, room: room, datetime: monday + 8.hours, schedule_type: fb)
Schedule.create(instructor: instructor_isa, room: room, datetime: monday + 9.hours, schedule_type: fb)
Schedule.create(instructor: instructor_geor, room: room, datetime: monday + 10.hours, schedule_type: fb)
Schedule.create(instructor: instructor_miguel, room: room, datetime: monday + 17.hours, schedule_type: fb)
Schedule.create(instructor: instructor_marilu, room: room, datetime: monday + 18.hours, schedule_type: fb)
Schedule.create(instructor: instructor_diana, room: room, datetime: monday + 19.hours, schedule_type: fb)
Schedule.create(instructor: instructor_sofi, room: room, datetime: monday + 20.hours, schedule_type: fb)
Schedule.create(instructor: instructor_diana, room: room, datetime: monday + 21.hours, schedule_type: fb)

#Tuesday
Schedule.create(instructor: instructor_samuel, room: room, datetime: tuesday + 6.hours + 15.minutes, schedule_type: lb)
Schedule.create(instructor: instructor_ale, room: room, datetime: tuesday + 7.hours, schedule_type: lb)
Schedule.create(instructor: instructor_isa, room: room, datetime: tuesday + 8.hours, schedule_type: lb)
Schedule.create(instructor: instructor_maca, room: room, datetime: tuesday + 9.hours, schedule_type: lb)
Schedule.create(instructor: instructor_geor, room: room, datetime: tuesday + 10.hours, schedule_type: lb)
Schedule.create(instructor: instructor_isa, room: room, datetime: tuesday + 17.hours, schedule_type: lb)
Schedule.create(instructor: instructor_miguel, room: room, datetime: tuesday + 18.hours, schedule_type: lb)
Schedule.create(instructor: instructor_sofi, room: room, datetime: tuesday + 19.hours, schedule_type: lb)
Schedule.create(instructor: instructor_diana, room: room, datetime: tuesday + 20.hours, schedule_type: lb)
Schedule.create(instructor: instructor_geor, room: room, datetime: tuesday + 21.hours, schedule_type: lb)

#Wednesday
Schedule.create(instructor: instructor_isa, room: room, datetime: wednesday + 6.hours + 15.minutes, schedule_type: ub)
Schedule.create(instructor: instructor_samuel, room: room, datetime: wednesday + 7.hours, schedule_type: ub)
Schedule.create(instructor: instructor_maca, room: room, datetime: wednesday + 8.hours, schedule_type: ub)
Schedule.create(instructor: instructor_geor, room: room, datetime: wednesday + 9.hours, schedule_type: ub)
Schedule.create(instructor: instructor_isa, room: room, datetime: wednesday + 10.hours, schedule_type: ub)
Schedule.create(instructor: instructor_miguel, room: room, datetime: wednesday + 17.hours, schedule_type: ub)
Schedule.create(instructor: instructor_marilu, room: room, datetime: wednesday + 18.hours, schedule_type: ub)
Schedule.create(instructor: instructor_diana, room: room, datetime: wednesday + 19.hours, schedule_type: ub)
Schedule.create(instructor: instructor_sofi, room: room, datetime: wednesday + 20.hours, schedule_type: ub)
Schedule.create(instructor: instructor_ale, room: room, datetime: wednesday + 21.hours, schedule_type: ub)

#Thursday
Schedule.create(instructor: instructor_ale, room: room, datetime: thursday + 6.hours + 15.minutes, schedule_type: abs)
Schedule.create(instructor: instructor_isa, room: room, datetime: thursday + 7.hours, schedule_type: abs)
Schedule.create(instructor: instructor_geor, room: room, datetime: thursday + 8.hours, schedule_type: abs)
Schedule.create(instructor: instructor_maca, room: room, datetime: thursday + 9.hours, schedule_type: abs)
Schedule.create(instructor: instructor_geor, room: room, datetime: thursday + 10.hours, schedule_type: abs)
Schedule.create(instructor: instructor_isa, room: room, datetime: thursday + 17.hours, schedule_type: abs)
Schedule.create(instructor: instructor_diana, room: room, datetime: thursday + 18.hours, schedule_type: abs)
Schedule.create(instructor: instructor_marilu, room: room, datetime: thursday + 19.hours, schedule_type: abs)
Schedule.create(instructor: instructor_ale, room: room, datetime: thursday + 20.hours, schedule_type: abs)
Schedule.create(instructor: instructor_miguel, room: room, datetime: thursday + 21.hours, schedule_type: abs)

#Friday
Schedule.create(instructor: instructor_samuel, room: room, datetime: friday + 6.hours + 15.minutes, schedule_type: fb)
Schedule.create(instructor: instructor_maca, room: room, datetime: friday + 7.hours, schedule_type: fb)
Schedule.create(instructor: instructor_isa, room: room, datetime: friday + 8.hours, schedule_type: fb)
Schedule.create(instructor: instructor_geor, room: room, datetime: friday + 9.hours, schedule_type: fb)
Schedule.create(instructor: instructor_isa, room: room, datetime: friday + 10.hours, schedule_type: fb)
Schedule.create(instructor: instructor_geor, room: room, datetime: friday + 17.hours, schedule_type: fb)
Schedule.create(instructor: instructor_miguel, room: room, datetime: friday + 18.hours, schedule_type: fb)
Schedule.create(instructor: instructor_diana, room: room, datetime: friday + 19.hours, schedule_type: fb)

#Saturday
Schedule.create(instructor: instructor_isa, room: room, datetime: saturday + 10.hours, schedule_type: lb)
Schedule.create(instructor: instructor_geor, room: room, datetime: saturday + 11.hours, schedule_type: lb)
Schedule.create(instructor: instructor_ale, room: room, datetime: saturday + 12.hours, schedule_type: lb)

#Next Monday
Schedule.create(instructor: instructor_ale, room: room, datetime: next_monday + 6.hours + 15.minutes, schedule_type: ub)
Schedule.create(instructor: instructor_samuel, room: room, datetime: next_monday + 7.hours, schedule_type: ub)
Schedule.create(instructor: instructor_maca, room: room, datetime: next_monday + 8.hours, schedule_type: ub)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_monday + 9.hours, schedule_type: ub)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_monday + 10.hours, schedule_type: ub)
Schedule.create(instructor: instructor_miguel, room: room, datetime: next_monday + 17.hours, schedule_type: ub)
Schedule.create(instructor: instructor_marilu, room: room, datetime: next_monday + 18.hours, schedule_type: ub)
Schedule.create(instructor: instructor_diana, room: room, datetime: next_monday + 19.hours, schedule_type: ub)
Schedule.create(instructor: instructor_sofi, room: room, datetime: next_monday + 20.hours, schedule_type: ub)
Schedule.create(instructor: instructor_diana, room: room, datetime: next_monday + 21.hours, schedule_type: ub)

#Next Tuesday
Schedule.create(instructor: instructor_samuel, room: room, datetime: next_tuesday + 6.hours + 15.minutes, schedule_type: abs)
Schedule.create(instructor: instructor_ale, room: room, datetime: next_tuesday + 7.hours, schedule_type: abs)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_tuesday + 8.hours, schedule_type: abs)
Schedule.create(instructor: instructor_maca, room: room, datetime: next_tuesday + 9.hours, schedule_type: abs)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_tuesday + 10.hours, schedule_type: abs)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_tuesday + 17.hours, schedule_type: abs)
Schedule.create(instructor: instructor_miguel, room: room, datetime: next_tuesday + 18.hours, schedule_type: abs)
Schedule.create(instructor: instructor_sofi, room: room, datetime: next_tuesday + 19.hours, schedule_type: abs)
Schedule.create(instructor: instructor_diana, room: room, datetime: next_tuesday + 20.hours, schedule_type: abs)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_tuesday + 21.hours, schedule_type: abs)

#Next Wednesday
Schedule.create(instructor: instructor_isa, room: room, datetime: next_wednesday + 6.hours + 15.minutes, schedule_type: fb)
Schedule.create(instructor: instructor_samuel, room: room, datetime: next_wednesday + 7.hours, schedule_type: fb)
Schedule.create(instructor: instructor_maca, room: room, datetime: next_wednesday + 8.hours, schedule_type: fb)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_wednesday + 9.hours, schedule_type: fb)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_wednesday + 10.hours, schedule_type: fb)
Schedule.create(instructor: instructor_miguel, room: room, datetime: next_wednesday + 17.hours, schedule_type: fb)
Schedule.create(instructor: instructor_marilu, room: room, datetime: next_wednesday + 18.hours, schedule_type: fb)
Schedule.create(instructor: instructor_diana, room: room, datetime: next_wednesday + 19.hours, schedule_type: fb)
Schedule.create(instructor: instructor_sofi, room: room, datetime: next_wednesday + 20.hours, schedule_type: fb)
Schedule.create(instructor: instructor_ale, room: room, datetime: next_wednesday + 21.hours, schedule_type: fb)

#Next Thursday
Schedule.create(instructor: instructor_ale, room: room, datetime: next_thursday + 6.hours + 15.minutes, schedule_type: lb)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_thursday + 7.hours, schedule_type: lb)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_thursday + 8.hours, schedule_type: lb)
Schedule.create(instructor: instructor_maca, room: room, datetime: next_thursday + 9.hours, schedule_type: lb)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_thursday + 10.hours, schedule_type: lb)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_thursday + 17.hours, schedule_type: lb)
Schedule.create(instructor: instructor_diana, room: room, datetime: next_thursday + 18.hours, schedule_type: lb)
Schedule.create(instructor: instructor_marilu, room: room, datetime: next_thursday + 19.hours, schedule_type: lb)
Schedule.create(instructor: instructor_ale, room: room, datetime: next_thursday + 20.hours, schedule_type: lb)
Schedule.create(instructor: instructor_miguel, room: room, datetime: next_thursday + 21.hours, schedule_type: lb)

#Next Friday
Schedule.create(instructor: instructor_samuel, room: room, datetime: next_friday + 6.hours + 15.minutes, schedule_type: abs)
Schedule.create(instructor: instructor_maca, room: room, datetime: next_friday + 7.hours, schedule_type: abs)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_friday + 8.hours, schedule_type: abs)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_friday + 9.hours, schedule_type: abs)
Schedule.create(instructor: instructor_isa, room: room, datetime: next_friday + 10.hours, schedule_type: abs)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_friday + 17.hours, schedule_type: abs)
Schedule.create(instructor: instructor_miguel, room: room, datetime: next_friday + 18.hours, schedule_type: abs)
Schedule.create(instructor: instructor_diana, room: room, datetime: next_friday + 19.hours, schedule_type: abs)

#Next Saturday
Schedule.create(instructor: instructor_isa, room: room, datetime: next_saturday + 10.hours, schedule_type: fb)
Schedule.create(instructor: instructor_geor, room: room, datetime: next_saturday + 11.hours, schedule_type: fb)
Schedule.create(instructor: instructor_ale, room: room, datetime: next_saturday + 12.hours, schedule_type: fb)

#Appointment
#appointment = Appointment.create(user: user, schedule: schedule_1, station_number: 1, status: 'BOOKED', start: schedule_1.datetime, description: "Con mi maestro favorito")

#Configuration
Config.create(key: "coupon_discount", value: "40")
Config.create(key: "referral_credit", value: "40")
