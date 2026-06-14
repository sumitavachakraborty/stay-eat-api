# db/seeds.rb
# Idempotent — clears all data then recreates from scratch.
# Run: rails db:seed

puts "Seeding database..."

# ── Destroy in FK-safe order ───────────────────────────────────────────────
[Reward, Booking, QualityCheck, Review, Property, Experience, Category, User].each(&:delete_all)

# ─────────────────────────────────────────────────────────────────────────────
# Users
# ─────────────────────────────────────────────────────────────────────────────
mara = User.create!(
  name:     "Mara Linden",
  email:    "mara@stayandeat.test",
  password: "password",
  role:     "host"
)

eli = User.create!(
  name:     "Eli Tanaka",
  email:    "eli@stayandeat.test",
  password: "password",
  role:     "traveller"
)

puts "  Created users: #{mara.name}, #{eli.name}"

# ─────────────────────────────────────────────────────────────────────────────
# Categories  (from data.jsx)
# ─────────────────────────────────────────────────────────────────────────────
categories_data = [
  { slug: "tiny",       label: "Tiny homes",       icon: "Cabin"    },
  { slug: "icons",      label: "Icons",             icon: "Sparkle"  },
  { slug: "tropical",   label: "Tropical",          icon: "Tree"     },
  { slug: "beachfront", label: "Beachfront",        icon: "Wave"     },
  { slug: "topworld",   label: "Top of the world",  icon: "Flag"     },
  { slug: "parks",      label: "National parks",    icon: "Mountain" },
  { slug: "cabins",     label: "Cabins",            icon: "Cabin"    },
  { slug: "views",      label: "Amazing views",     icon: "Mountain" },
  { slug: "mansions",   label: "Mansions",          icon: "Home"     },
]

categories_data.each { |c| Category.create!(c) }
puts "  Created #{Category.count} categories"

# ─────────────────────────────────────────────────────────────────────────────
# Experiences  (from data.jsx)
# ─────────────────────────────────────────────────────────────────────────────
experiences_data = [
  {
    slug:      "e1",
    name:      "Foraged dinner with Lina",
    place:     "Cedar Hollow",
    host_name: "Lina",
    price:     78,
    img:       "https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=800&q=80",
  },
  {
    slug:      "e2",
    name:      "Pre-dawn alpine hike",
    place:     "Ridge route · 4h",
    host_name: "Mateo",
    price:     52,
    img:       "https://images.unsplash.com/photo-1551632811-561732d1e306?w=800&q=80",
  },
  {
    slug:      "e3",
    name:      "Wood-fired pottery class",
    place:     "Studio Onna",
    host_name: "Ines",
    price:     64,
    img:       "https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=800&q=80",
  },
  {
    slug:      "e4",
    name:      "Lake-side sauna ritual",
    place:     "Boathouse",
    host_name: "Hugo",
    price:     90,
    img:       "https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=800&q=80",
  },
]

experiences_data.each { |e| Experience.create!(e) }
puts "  Created #{Experience.count} experiences"

# ─────────────────────────────────────────────────────────────────────────────
# Properties  (from data.jsx + web-detail.jsx)
# ─────────────────────────────────────────────────────────────────────────────
# Detail data for p2 (Lake Reflection House) from web-detail.jsx
lake_amenities = [
  { icon: "Wifi",     label: "Fiber Wi-Fi · 600 Mbps"   },
  { icon: "Bed",      label: "Memory-foam queen bed"     },
  { icon: "Coffee",   label: "Slow-pour coffee bar"      },
  { icon: "Mountain", label: "Lake & ridge views"        },
  { icon: "Tree",     label: "Private forest plot"       },
  { icon: "Sparkle",  label: "Pre-cleaned · Mar 23"      },
]

lake_quality_rooms = ["Bedroom", "Bathroom", "Kitchen", "Living", "Exterior"]

properties_data = [
  {
    # p1
    name:          "A-Frame Pinewood Cabin",
    place:         "Aspen, Colorado",
    sub:           "Mountain and valley views",
    dates:         "Mar 14 — 19",
    price:         568,
    rating:        5.0,
    reviews:       128,
    favorite:      true,
    badge:         "Guest favorite",
    photos:        [
      "https://images.unsplash.com/photo-1518780664697-55e3ad937233?w=900&q=80",
      "https://images.unsplash.com/photo-1542718610-a1d656d1884c?w=900&q=80",
      "https://images.unsplash.com/photo-1449158743715-0a90ebb6d2d8?w=900&q=80",
    ],
    host_name:     "Mara Linden",
    host_initial:  "M",
    guests:        4,
    bedrooms:      2,
    beds:          2,
    baths:         1.0,
    description:   "A classic A-frame cabin nestled in the Aspen pines with panoramic mountain and valley views. Ski-in/ski-out access and a wood-burning fireplace.",
    amenities:     [
      { icon: "Wifi",     label: "High-speed Wi-Fi"          },
      { icon: "Mountain", label: "Mountain & valley views"   },
      { icon: "Tree",     label: "Ski-in/ski-out access"     },
      { icon: "Sparkle",  label: "Pre-cleaned before arrival" },
    ],
    quality_rooms: ["Bedroom", "Loft", "Bathroom", "Kitchen", "Exterior"],
  },
  {
    # p2 — Lake Reflection House (full detail from web-detail.jsx)
    name:          "Lake Reflection House",
    place:         "Lago di Braies, Italy",
    sub:           "Mountain and lake views",
    dates:         "Mar 23 — 28",
    price:         380,
    rating:        4.98,
    reviews:       412,
    favorite:      false,
    badge:         "Guest favorite",
    photos:        [
      "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=900&q=80",
      "https://images.unsplash.com/photo-1502784444187-359ac186c5bb?w=900&q=80",
    ],
    host_name:     "Mara Linden",
    host_initial:  "M",
    guests:        4,
    bedrooms:      2,
    beds:          2,
    baths:         1.5,
    description:   "Wake up to a mirror-still lake framed by the Dolomites. This modern cabin sits on the shores of Lago di Braies with a private jetty, quality-verified before every stay.",
    amenities:     lake_amenities,
    quality_rooms: lake_quality_rooms,
  },
  {
    # p3
    name:          "Cliffside Cedar Studio",
    place:         "Lofoten, Norway",
    sub:           "Fjord and ocean views",
    dates:         "Feb 17 — 22",
    price:         455,
    rating:        4.9,
    reviews:       211,
    favorite:      false,
    badge:         "Guest favorite",
    photos:        [
      "https://images.unsplash.com/photo-1449158743715-0a90ebb6d2d8?w=900&q=80",
      "https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=900&q=80",
    ],
    host_name:     "Mara Linden",
    host_initial:  "M",
    guests:        2,
    bedrooms:      1,
    beds:          1,
    baths:         1.0,
    description:   "A cedar studio perched on a Lofoten cliff with uninterrupted fjord and ocean views. Northern lights visible most nights in winter.",
    amenities:     [
      { icon: "Wifi",    label: "Satellite Wi-Fi"          },
      { icon: "Mountain", label: "Fjord & ocean views"     },
      { icon: "Sparkle", label: "Pre-cleaned before arrival" },
    ],
    quality_rooms: ["Bedroom", "Bathroom", "Kitchen", "Exterior"],
  },
  {
    # p4
    name:          "Glass Forest Retreat",
    place:         "Olympic Peninsula, WA",
    sub:           "Old-growth rainforest",
    dates:         "Apr 02 — 07",
    price:         620,
    rating:        4.92,
    reviews:       87,
    favorite:      false,
    badge:         "Guest favorite",
    photos:        [
      "https://images.unsplash.com/photo-1542718610-a1d656d1884c?w=900&q=80",
      "https://images.unsplash.com/photo-1509600110300-21b9d5fedeb7?w=900&q=80",
    ],
    host_name:     "Mara Linden",
    host_initial:  "M",
    guests:        4,
    bedrooms:      2,
    beds:          3,
    baths:         2.0,
    description:   "A glass-walled retreat embedded in the ancient Olympic rainforest. Floor-to-ceiling windows bring the moss-covered canopy right into your living room.",
    amenities:     [
      { icon: "Wifi",    label: "High-speed Wi-Fi"          },
      { icon: "Tree",    label: "Old-growth forest access"  },
      { icon: "Bed",     label: "King bed with forest view" },
      { icon: "Sparkle", label: "Pre-cleaned before arrival" },
    ],
    quality_rooms: ["Master Bedroom", "Bathroom", "Kitchen", "Living", "Exterior"],
  },
  {
    # p5
    name:          "Floating Bamboo Hut",
    place:         "Langkawi, Malaysia",
    sub:           "Private floating platform",
    dates:         "May 04 — 10",
    price:         173,
    rating:        4.87,
    reviews:       304,
    favorite:      false,
    badge:         nil,
    photos:        [
      "https://images.unsplash.com/photo-1540541338287-41700207dee6?w=900&q=80",
      "https://images.unsplash.com/photo-1582719508461-905c673771fd?w=900&q=80",
    ],
    host_name:     "Mara Linden",
    host_initial:  "M",
    guests:        2,
    bedrooms:      1,
    beds:          1,
    baths:         1.0,
    description:   "A hand-built bamboo hut on a private floating platform in the Langkawi archipelago. Fall asleep to the sound of water, wake up to jungle birds.",
    amenities:     [
      { icon: "Wave",    label: "Private water platform"    },
      { icon: "Tree",    label: "Jungle & mangrove access"  },
      { icon: "Sparkle", label: "Pre-cleaned before arrival" },
    ],
    quality_rooms: ["Bedroom", "Bathroom", "Deck", "Exterior"],
  },
  {
    # p6
    name:          "Geodesic Dome · Aurora",
    place:         "Tromsø, Norway",
    sub:           "Northern-lights window",
    dates:         "Dec 11 — 16",
    price:         412,
    rating:        5.0,
    reviews:       96,
    favorite:      false,
    badge:         "Guest favorite",
    photos:        [
      "https://images.unsplash.com/photo-1517824806704-9040b037703b?w=900&q=80",
    ],
    host_name:     "Mara Linden",
    host_initial:  "M",
    guests:        2,
    bedrooms:      1,
    beds:          1,
    baths:         1.0,
    description:   "A geodesic glass dome in Arctic Norway designed for aurora watching. The transparent canopy frames the northern lights like a living painting.",
    amenities:     [
      { icon: "Sparkle", label: "Aurora-watch dome roof"    },
      { icon: "Bed",     label: "King bed under the stars"  },
      { icon: "Wifi",    label: "High-speed Wi-Fi"          },
      { icon: "Sparkle", label: "Pre-cleaned before arrival" },
    ],
    quality_rooms: ["Bedroom", "Bathroom", "Living", "Exterior"],
  },
  {
    # p7
    name:          "Treehouse on Stilts",
    place:         "Ucluelet, BC",
    sub:           "Pacific coast forest",
    dates:         "Jun 02 — 07",
    price:         298,
    rating:        4.94,
    reviews:       142,
    favorite:      false,
    badge:         nil,
    photos:        [
      "https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=900&q=80",
    ],
    host_name:     "Mara Linden",
    host_initial:  "M",
    guests:        3,
    bedrooms:      1,
    beds:          2,
    baths:         1.0,
    description:   "A cedar treehouse raised on stilts among the ancient Pacific coast firs, minutes from the Wild Pacific Trail and whale-watching kayak launches.",
    amenities:     [
      { icon: "Tree",    label: "Pacific coast forest"      },
      { icon: "Wifi",    label: "Starlink Wi-Fi"            },
      { icon: "Sparkle", label: "Pre-cleaned before arrival" },
    ],
    quality_rooms: ["Bedroom", "Bathroom", "Living", "Deck"],
  },
  {
    # p8
    name:          "Adobe Desert Casita",
    place:         "Joshua Tree, CA",
    sub:           "High-desert minimalist",
    dates:         "Apr 19 — 23",
    price:         244,
    rating:        4.89,
    reviews:       273,
    favorite:      false,
    badge:         "Guest favorite",
    photos:        [
      "https://images.unsplash.com/photo-1518780664697-55e3ad937233?w=900&q=80",
    ],
    host_name:     "Mara Linden",
    host_initial:  "M",
    guests:        2,
    bedrooms:      1,
    beds:          1,
    baths:         1.0,
    description:   "A handmade adobe casita in the high desert of Joshua Tree — thick walls keep it cool in summer and warm at night under a star-filled sky.",
    amenities:     [
      { icon: "Mountain", label: "Desert & boulder views"   },
      { icon: "Bed",      label: "King bed, blackout shades" },
      { icon: "Wifi",     label: "High-speed Wi-Fi"         },
      { icon: "Sparkle",  label: "Pre-cleaned before arrival" },
    ],
    quality_rooms: ["Bedroom", "Bathroom", "Kitchen", "Patio"],
  },
]

properties = properties_data.map do |pd|
  Property.create!(pd.merge(host: mara))
end

puts "  Created #{Property.count} properties"

# Quick references for seeding quality checks
p2 = properties[1]  # Lake Reflection House
p4 = properties[3]  # Glass Forest Retreat
p6 = properties[5]  # Geodesic Dome · Aurora

# ─────────────────────────────────────────────────────────────────────────────
# Quality Checks  (from web-host.jsx queue)
# ─────────────────────────────────────────────────────────────────────────────
rooms_for_qc1 = [
  { id: "bedroom",  name: "Master bedroom",    count: 6, required: 4, status: "verified", img: "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=600&q=80" },
  { id: "bath",     name: "Bathroom",          count: 4, required: 4, status: "verified", img: "https://images.unsplash.com/photo-1552321554-5fefe8c9ef14?w=600&q=80" },
  { id: "kitchen",  name: "Kitchen",           count: 5, required: 4, status: "verified", img: "https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=600&q=80" },
  { id: "living",   name: "Living room",       count: 3, required: 4, status: "pending",  img: "https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=600&q=80" },
  { id: "exterior", name: "Exterior & deck",   count: 4, required: 3, status: "verified", img: "https://images.unsplash.com/photo-1518780664697-55e3ad937233?w=600&q=80" },
  { id: "extras",   name: "Linens & supplies", count: 0, required: 3, status: "todo",     img: nil },
]

qc1 = QualityCheck.create!(
  property:   p2,
  guest_name: "Eli Tanaka",
  check_in:   Time.zone.parse("2026-03-23 11:00:00"),
  note:       "Photos due in 2h 14m",
  state:      "progress",
  pct:        64,
  rooms:      rooms_for_qc1
)

qc2 = QualityCheck.create!(
  property:   p4,
  guest_name: "Sara Bennet",
  check_in:   Time.zone.parse("2026-03-24 09:00:00"),
  note:       "Cleaning crew booked",
  state:      "scheduled",
  pct:        0,
  rooms:      []
)

qc3 = QualityCheck.create!(
  property:   p6,
  guest_name: "Riku Mori · group of 3",
  check_in:   Time.zone.parse("2026-03-25 13:00:00"),
  note:       "Photos due in 30h",
  state:      "scheduled",
  pct:        0,
  rooms:      []
)

puts "  Created #{QualityCheck.count} quality checks"

# ─────────────────────────────────────────────────────────────────────────────
# Bookings  (seed a confirmed booking for Eli at Lake Reflection House)
# ─────────────────────────────────────────────────────────────────────────────
Booking.create!(
  user:      eli,
  property:  p2,
  check_in:  Date.new(2026, 3, 23),
  check_out: Date.new(2026, 3, 28),
  guests:    2,
  status:    "confirmed"
)

puts "  Created #{Booking.count} bookings"

# ─────────────────────────────────────────────────────────────────────────────
# Rewards  (from REWARDS array in web-host.jsx — belongs to Mara)
# ─────────────────────────────────────────────────────────────────────────────
rewards_data = [
  { tier: "Verified",      met: true,  description: "Photo Quality Checks on every booking", count_label: "92 / 92"   },
  { tier: "Verified+",     met: true,  description: "4.9★ for 6 months · sub-2hr response",  count_label: "4.97 ★"   },
  { tier: "Sustainer",     met: false, description: "Reviewed by 200 guests",                count_label: "142 / 200" },
  { tier: "stay and eat Circle", met: false, description: "Top 1% in your region",                 count_label: "— locked"  },
]

rewards_data.each { |r| Reward.create!(r.merge(user: mara)) }
puts "  Created #{Reward.count} rewards"

# ─────────────────────────────────────────────────────────────────────────────
# Review  (sample review from web-host.jsx sidebar)
# ─────────────────────────────────────────────────────────────────────────────
Review.create!(
  property: properties[0], # Pinewood Cabin
  author:   "Hana K.",
  rating:   5,
  body:     "The Quality Check photos arrived right on time. We walked into a cabin that looked exactly like the listing — and the welcome basket was a beautiful surprise."
)

puts "  Created #{Review.count} reviews"
puts "Seeding complete! ✓"
puts ""
puts "Seeded logins:"
puts "  Host:      mara@stayandeat.test / password"
puts "  Traveller: eli@stayandeat.test  / password"
