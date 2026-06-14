# syntax=docker/dockerfile:1
# ── Stage: builder ──────────────────────────────────────────────────────────
FROM ruby:3.3.6-slim AS builder

# Install system dependencies needed to compile native gems
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy Gemfile first so Docker can cache the bundle layer
COPY Gemfile ./

RUN bundle install --jobs 4 --retry 3

# ── Stage: runtime ───────────────────────────────────────────────────────────
FROM ruby:3.3.6-slim AS runtime

# Install only the runtime libraries (no build tools)
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      libpq5 \
      postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy installed gems from builder stage
COPY --from=builder /usr/local/bundle /usr/local/bundle

# Copy application source
COPY . .

# Make bin scripts executable
RUN chmod +x bin/rails bin/rake bin/setup bin/docker-entrypoint

EXPOSE 3001

ENTRYPOINT ["bin/docker-entrypoint"]
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3001"]
