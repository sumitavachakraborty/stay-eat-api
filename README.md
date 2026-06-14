# se-backend — hearth API

Rails 8 API-only backend for the **hearth** homestay platform ("stay-and-eat").

## Stack

| Layer | Tech |
|---|---|
| Language | Ruby 3.3.6 |
| Framework | Rails 8.0 (API-only) |
| Database | PostgreSQL 15+ |
| Auth | JWT (HS256, 7-day expiry) + bcrypt |
| Server | Puma (port 3001) |
| CORS | rack-cors |

---

## Local development

### Prerequisites
- Ruby 3.3.6 (use `rbenv` or `asdf`)
- PostgreSQL running locally (or via Docker)

### Setup

```bash
cd se-backend
bundle install
rails db:create db:migrate db:seed
rails server -p 3001
```

The API will be available at `http://localhost:3001`.

---

## Environment variables

| Variable | Default | Description |
|---|---|---|
| `DATABASE_HOST` | `localhost` | Postgres host |
| `DATABASE_PORT` | `5432` | Postgres port |
| `DATABASE_USER` | `postgres` | Postgres user |
| `DATABASE_PASSWORD` | `postgres` | Postgres password |
| `DATABASE_URL` | — | Full connection URL (overrides above in production) |
| `PORT` | `3001` | Puma listen port |
| `RAILS_ENV` | `development` | Rails environment |
| `JWT_SECRET` | `secret_key_base` | JWT signing secret (set in production!) |
| `SECRET_KEY_BASE` | hard-coded dev string | Rails secret key base |
| `CORS_ORIGINS` | `http://localhost:3000,http://localhost:3002` | Comma-separated allowed origins |
| `RAILS_MAX_THREADS` | `5` | Puma thread count + DB pool size |

---

## Docker

```bash
# Build
docker build -t se-backend .

# Run (assumes Postgres on the same network)
docker run --rm -p 3001:3001 \
  -e DATABASE_HOST=db \
  -e DATABASE_USER=postgres \
  -e DATABASE_PASSWORD=postgres \
  -e RAILS_ENV=development \
  se-backend
```

---

## Seeded logins

| Role | Email | Password |
|---|---|---|
| Host | `mara@hearth.test` | `password` |
| Traveller | `eli@hearth.test` | `password` |

---

## API reference

All endpoints are under `/api/v1`. JSON in, JSON out. Authenticated endpoints require:

```
Authorization: Bearer <token>
```

---

### Health check

```
GET /up
→ 200 OK
```

---

### Properties

#### List all properties
```
GET /api/v1/properties

→ 200 {
  "properties": [
    {
      "id": 1,
      "name": "Lake Reflection House",
      "place": "Lago di Braies, Italy",
      "sub": "Mountain and lake views",
      "dates": "Mar 23 — 28",
      "price": 380,
      "rating": 4.98,
      "reviews": 412,
      "favorite": false,
      "badge": "Guest favorite",
      "photos": ["https://..."]
    }
  ]
}
```

#### Get property detail
```
GET /api/v1/properties/:id

→ 200 {
  "property": {
    "id": 2,
    "name": "Lake Reflection House",
    ...all summary fields...,
    "host_name": "Mara Linden",
    "host_initial": "M",
    "guests": 4,
    "bedrooms": 2,
    "beds": 2,
    "baths": 1.5,
    "description": "...",
    "amenities": [{ "icon": "Wifi", "label": "Fiber Wi-Fi · 600 Mbps" }],
    "quality_rooms": ["Bedroom", "Bathroom", "Kitchen", "Living", "Exterior"],
    "price_breakdown": {
      "nightly": 380,
      "nights": 5,
      "cleaning": 80,
      "total": 1980
    }
  }
}
```

---

### Categories
```
GET /api/v1/categories

→ 200 {
  "categories": [
    { "id": "tiny", "label": "Tiny homes", "icon": "Cabin" }
  ]
}
```

---

### Experiences
```
GET /api/v1/experiences

→ 200 {
  "experiences": [
    { "id": "e1", "name": "Foraged dinner with Lina", "place": "Cedar Hollow",
      "host": "Lina", "price": 78, "img": "https://..." }
  ]
}
```

---

### Auth

#### Sign up
```
POST /api/v1/auth/signup
Body: { "name": "Jane", "email": "jane@example.com", "password": "secret", "role": "traveller" }

→ 201 { "token": "eyJ...", "user": { "id": 3, "name": "Jane", "email": "jane@example.com", "role": "traveller" } }
```

#### Log in
```
POST /api/v1/auth/login
Body: { "email": "eli@hearth.test", "password": "password" }

→ 200 { "token": "eyJ...", "user": { ... } }
→ 401 { "error": "Invalid email or password" }  (on bad creds)
```

#### Get current user (Bearer required)
```
GET /api/v1/auth/me

→ 200 { "user": { "id": 2, "name": "Eli Tanaka", "email": "eli@hearth.test", "role": "traveller" } }
→ 401 { "error": "Missing token" }
```

---

### Bookings (Bearer required)

#### List my bookings
```
GET /api/v1/bookings

→ 200 {
  "bookings": [{
    "id": 1,
    "property_id": 2,
    "property": { "id": 2, "name": "Lake Reflection House", "place": "...", "photo": "https://..." },
    "check_in": "2026-03-23",
    "check_out": "2026-03-28",
    "guests": 2,
    "status": "confirmed",
    "created_at": "2026-01-01T00:00:00.000Z"
  }]
}
```

#### Create a booking
```
POST /api/v1/bookings
Body: { "property_id": 2, "check_in": "2026-04-01", "check_out": "2026-04-06", "guests": 2 }

→ 201 { "booking": { ... } }
```

---

### Host dashboard (Bearer + role=host required)

#### Analytics
```
GET /api/v1/host/analytics

→ 200 {
  "stats": {
    "confirmed_bookings": 14,
    "quality_checks_pending": 3,
    "avg_approval_time": "11 min",
    "payout": 8420,
    "points": 2148,
    "points_delta": 328
  },
  "rewards": [
    { "tier": "Verified",  "met": true,  "desc": "Photo Quality Checks on every booking", "count": "92 / 92" },
    { "tier": "Verified+", "met": true,  "desc": "4.9★ for 6 months · sub-2hr response",  "count": "4.97 ★"  },
    { "tier": "Sustainer", "met": false, "desc": "Reviewed by 200 guests",                "count": "142 / 200" },
    { "tier": "Hearth Circle", "met": false, "desc": "Top 1% in your region",             "count": "— locked" }
  ]
}
```

#### List host listings
```
GET /api/v1/host/listings

→ 200 { "listings": [ ...Property summaries... ] }
```

#### Create a listing
```
POST /api/v1/host/listings
Body: { "name": "My Cabin", "place": "Somewhere", "price": 200, ... }

→ 201 { "property": { ... } }
```

#### Quality check queue
```
GET /api/v1/host/quality_checks

→ 200 {
  "quality_checks": [{
    "id": 1,
    "property": { "name": "Lake Reflection House", "photo": "https://..." },
    "guest": "Eli Tanaka",
    "check_in": "2026-03-23T11:00:00.000Z",
    "note": "Photos due in 2h 14m",
    "state": "progress",
    "pct": 64
  }]
}
```

#### Quality check detail (with rooms)
```
GET /api/v1/host/quality_checks/:id

→ 200 {
  "quality_check": {
    ...summary fields...,
    "rooms": [
      { "id": "bedroom", "name": "Master bedroom", "count": 6, "required": 4, "status": "verified", "img": "https://..." },
      { "id": "bath",    "name": "Bathroom",        "count": 4, "required": 4, "status": "verified", "img": "https://..." },
      { "id": "kitchen", "name": "Kitchen",         "count": 5, "required": 4, "status": "verified", "img": "https://..." },
      { "id": "living",  "name": "Living room",     "count": 3, "required": 4, "status": "pending",  "img": "https://..." },
      { "id": "exterior","name": "Exterior & deck", "count": 4, "required": 3, "status": "verified", "img": "https://..." },
      { "id": "extras",  "name": "Linens & supplies","count": 0,"required": 3, "status": "todo",     "img": null }
    ]
  }
}
```
