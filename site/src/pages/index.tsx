import Head from 'next/head';
import { GetStaticProps } from 'next';
import { PlaylistCity } from '@/components/Playlist';
import { FilterablePlaylists } from '../components/FilterablePlaylists';
import styles from '../styles/Home.module.css';

const playlistsJson = require(`./Playlists.json`);

export default function Home({ playlists }: IndexPageProps) {
  return (
    <div className={styles.container}>
      <Head>
        <title>Playlists for Upcoming Concerts</title>
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>Upcoming</h1>

        <p className={styles.description}>
          Each playlist contains the top songs for artists who are performing in
          that city in the coming period. Playlists are updated daily.
        </p>

        <FilterablePlaylists playlists={playlists} />
      </main>

      <footer className={styles.footer}>
        <div>
          <p>
            Playlists are updated daily using Concert data from{` `}
            <a href="https://www.songkick.com">Songkick</a>.
          </p>
        </div>
        <div>
          <a
            href="https://eoinobrien.ie"
            target="_blank"
            rel="noopener noreferrer"
          >
            Created by Eoin O&apos;Brien
          </a>
        </div>
      </footer>
    </div>
  );
}

export const getStaticProps: GetStaticProps = async () => ({
  props: {
    playlists: playlistsJson,
  },
});

export type IndexPageProps = {
  playlists: PlaylistCity[];
};
