FROM node:20-alpine

# প্রয়োজনীয় বাইনারি ও টুলস ইনস্টল
RUN apk add --no-cache libc6-compat python3 make g++

WORKDIR /app

# রুট এবং সাব-ফোল্ডারের সব package.json ও লক ফাইল একবারে কপি
COPY package*.json ./
COPY apps/backend/package*.json ./apps/backend/
COPY apps/storefront/package*.json ./apps/storefront/

# npm workspaces-এর মাধ্যমে সব ডিপেন্ডেন্সি নিখুঁতভাবে ইনস্টল
RUN npm ci --legacy-peer-deps

# পুরো প্রজেক্টের সব ফাইল কপি
COPY . .

# মেমোরি লিমিট বাড়িয়ে টার্বো বিল্ড রান
ENV NODE_OPTIONS="--max-old-space-size=3072"
RUN npm run build

EXPOSE 9000

# মনোরেপোর রুট থেকে টার্বো স্টার্ট স্ক্রিপ্ট রান করা হচ্ছে
CMD ["npm", "run", "start"]