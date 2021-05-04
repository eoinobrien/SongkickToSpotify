const withOptimizedImages = require('next-optimized-images');

module.exports = withOptimizedImages({
  future: {
    webpack5: true,
  },
  assetPrefix: '.',
});
