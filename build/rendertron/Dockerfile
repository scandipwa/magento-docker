FROM node:10-slim

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont git \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* 

# Uncomment to skip the chromium download when installing puppeteer. If you do,
# you'll need to launch puppeteer with:
#     browser.launch({executablePath: 'google-chrome-unstable'})
ENV PORT=8083

# Install puppeteer so it's available in the container.
RUN git clone https://github.com/GoogleChrome/rendertron.git \
    && cd rendertron \
    && npm install \
    && npm run build \
    # Patching Puppeteer launch arguments \
    && DEFAULT_ARGS="\['--no-sandbox'\]" \
    && ARGS="\['--no-sandbox', '--disable-dev-shm-usage', '--ignore-certificate-errors'\], ignoreHTTPSErrors: true" \
    && sed -i "s/$DEFAULT_ARGS/$ARGS/g" build/rendertron.js

WORKDIR /rendertron

CMD ["npm","run","start"]