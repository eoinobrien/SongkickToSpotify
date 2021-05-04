import Head from 'next/head';
import styles from '../styles/Home.module.css';

import { Playlists } from '../components/Playlists';
import { GetStaticProps } from 'next';
import { PlaylistType } from '@/components/Playlist';

export default function Home({playlists}: IndexPageProps) {
  return (
    <div className={styles.container}>
      <Head>
        <title>Create Next App</title>
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>
          Upcoming <a href="https://nextjs.org">Next.js!</a>
        </h1>

        <Playlists playlists={playlists}/>
      </main>

      <footer className={styles.footer}>
        <a
          href="https://eoinobrien.ie"
          target="_blank"
          rel="noopener noreferrer"
        >
          Created by Eoin O'Brien
        </a>
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
