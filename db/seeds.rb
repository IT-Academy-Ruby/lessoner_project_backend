# Create admin
User.create!(name: 'thelessoner', email: 'lessonerteam@gmail.com',
             password: ENV['ADMIN_PASSWORD'], birthday: '2000-01-01', 
             admin_type: true, email_confirmed: true, verified: true)

# Create main categories
Category.create!([{                                                                                                                                
  name: "IT",                                                                          
  description: "Video courses for beginner IT-specialists. Here you will find courses on Ruby, QA, Frontend Developer, ASP and more.",                                                                                          
  image_url: "https://lessoner.s3.amazonaws.com/kxmziucj4fvbnxadohcst7bw1lwe"     
},
{                                                                         
  name: "Psychology",                                                                  
  description: "Psycology is the study of the mind, how it works, and how it affects behavior",
  image_url: "https://lessoner.s3.amazonaws.com/63wpxeg4eoqa9tqjfhh9ori0ku9k"
},
{      
  name: "Design",
  description: "Design education: 30+ professions and 1000+ courses in graphic, web design, UX and UI, product and industrial design. Current approaches to learning. Opportunity to study disciplines from scratch and improve your skills..",
  image_url: "https://lessoner.s3.amazonaws.com/hbhmf1ichh82smzqwcoycgbw895e"
},
{  
  name: "Finance",
  description: "It cool category!!!",
  image_url: "https://lessoner.s3.amazonaws.com/3ruep0rlkrspb2mwalpiz3cy69mi"
},
{  
  name: "Languages",
  description: "For begining",
  image_url: "https://lessoner.s3.amazonaws.com/7ncg5put3swh2vsp0luyusm58s7b"
},
{  
  name: "Business",
  description: "Discover a large collection of videos on the topic of business and entrepreneurship, that help you to learn the basics of financial literacy and help you organize your business processes.",
  image_url: "https://lessoner.s3.amazonaws.com/uhkenf3nwck335setnu97dyu6hcu"
},
{  
  name: "Fitness",
  description: "Find free video workouts for dance, yoga, indoor cycling and more",
  image_url: "https://lessoner.s3.amazonaws.com/i3bc8lb8foqj5n3qggcqgq4ajuq0"
},
{  
  name: "Music",
  description: "Videos and trainings on all aspects of music: harmony, theory, improvisation, arrangement, composition, melody creation, song creation, guitar.",
  image_url: "https://lessoner.s3.amazonaws.com/z1d01zsvt0t6lomsqesenp8fytfx"
}])
