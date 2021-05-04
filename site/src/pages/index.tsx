import Head from 'next/head';
import styles from '../styles/Home.module.css';

import { Playlists } from '../components/Playlists';
import { GetStaticProps } from 'next';
import { PlaylistType } from '@/components/Playlist';

export default function Home({ playlists }: IndexPageProps) {
  return (
    <div className={styles.container}>
      <Head>
        <title>Playlists for Upcoming Concerts</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>Upcoming</h1>

        <p  className={styles.description}>Each playlist contains the top songs for artists who are performing in that city in the coming period. Playlists are updated daily.</p>

        <Playlists playlists={playlists} />
      </main>

      <footer className={styles.footer}>
        <div>
          <p>
            Playlists are updated daily using Concert data from{' '}
            <a href="https://www.songkick.com">Songkick</a>.
          </p>
        </div>
        <div>
          <a
            href="https://eoinobrien.ie"
            target="_blank"
            rel="noopener noreferrer"
          >
            Created by Eoin O'Brien
          </a>
        </div>
      </footer>
    </div>
  );
}

export const getStaticProps: GetStaticProps = async (context) => {
  const playlists = require('./Playlists.json');

  return {
    props: {
      playlists: playlists,
    },
  };
};

export type IndexPageProps = {
  playlists: PlaylistType[];
};
