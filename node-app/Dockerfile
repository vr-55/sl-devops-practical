FROM node:20.11.0-bookworm AS builder

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci --omit=dev

# Copy the application source code
COPY . .


FROM gcr.io/distroless/nodejs20-debian12 AS runner

ENV NODE_ENV=production
ENV MONGODB_URL=mongodb://mongo:27017/database


# Set the working directory. 
WORKDIR /app

# COPY ARTIFACTS.
COPY --from=builder /app ./

# security hardening
USER nonroot

# entrypoint definition.
CMD ["server.js"]
