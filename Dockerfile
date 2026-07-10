FROM node:20-alpine AS base

# এডমিন ও নোড বাইনারি বিল্ডের জন্য প্রয়োজনীয় টুলস
RUN apk add --no-cache libc6-compat python3 make g++

WORKDIR /app

# ডিপেন্ডেন্সি ইনস্টল
COPY package*.json ./
RUN npm ci --legacy-peer-deps

# সব ফাইল কপি
COPY . .

# মেমোরি লিমিট বাড়িয়ে প্রোডাকশন বিল্ড রান
ENV NODE_OPTIONS="--max-old-space-size=3072"
RUN npm run build

EXPOSE 9000

CMD ["npm", "run", "start"]