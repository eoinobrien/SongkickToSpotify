import Document, {
  DocumentContext,
  Head,
  Html,
  Main,
  NextScript,
} from 'next/document';
import React from 'react';

class MyDocument extends Document {
  static async getInitialProps(ctx: DocumentContext) {
    const initialProps = await Document.getInitialProps(ctx);

    return initialProps;
  }

  render() {
    return (
      <Html lang="en">
        <Head>
          <link href="./fonts/fonts.css" rel="stylesheet" />
          <link rel="icon" href="./favicon.ico" />
          <link
            rel="preload"
            href="./fonts/BebasNeue-Regular.ttf"
            as="font"
            crossOrigin=""
          />
          <script
            async
            defer
            data-domain="eoinobrien.github.io/songkicktospotify"
            src="https://plausible.eoin.co/js/plausible.js"
          />
        </Head>
        <body>
          <Main />
          <NextScript />
        </body>
      </Html>
    );
  }
}

export default MyDocument;
