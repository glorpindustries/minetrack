FROM node:16-alpine

# Install tini and sqlite3 using Alpine package manager
RUN apk add --no-cache tini sqlite

# Copy tini to correct location if needed
# (optional — often already installed with correct path in Alpine)
# RUN cp /usr/bin/tini /sbin/tini

# Set tini as init system
ENTRYPOINT ["/sbin/tini", "--"]

# Set working directory
WORKDIR /usr/src/minetrack
COPY . .

# Build minetrack
RUN npm install --build-from-source \
 && npm run build

# Create non-root user
RUN addgroup -g 10043 minetrack \
 && adduser -D -u 10042 -G minetrack minetrack \
 && chown -R minetrack:minetrack /usr/src/minetrack
USER minetrack

EXPOSE 8080

CMD ["node", "main.js"]
