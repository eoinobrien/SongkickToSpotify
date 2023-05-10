import Head from 'next/head';
import { useRouter } from 'next/router';
import { GetStaticProps } from 'next';
import { PlaylistCity } from '@/components/Playlist';
import { Ducky } from '@/components/Ducky';
import { FilterablePlaylists } from '../components/FilterablePlaylists';
import styles from '../styles/Home.module.css';

const playlistsJson = require(`./Playlists.json`);

export default function Home({ playlists }: IndexPageProps) {
  const router = useRouter();
  const { source } = router.query;

  const cityBreezeSounds =
    source?.toString().toLowerCase() === `citybreezesounds`;

  return (
    <div className={styles.container}>
      <Head>
        <title>Playlists for Upcoming Concerts</title>
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>Upcoming</h1>
        {cityBreezeSounds && <h2>City Breeze Sounds!</h2>}
        
        <h2 className={styles.projectBroken}>Unfortunately, due to the <a href="https://www.songkick.com/developer">Songkick API</a> no longer supporting hobby applications, this project no longer works</h2>

        <p className={styles.description}>
          Each playlist contains the top songs for artists who are performing in
          that city in the coming period. Playlists are updated daily.
        </p>
                
        <FilterablePlaylists
          playlists={playlists}
          source={source?.toString().toLowerCase()}
        />
      </main>

      {cityBreezeSounds && <Ducky />}

      <footer className={styles.footer}>
        <p>
          Playlists are updated daily using Concert data from{` `}
          <a href="https://www.songkick.com">Songkick</a>.
        </p>
        <p>
          <a
            href="https://github.com/eoinobrien/SongkickToSpotify"
            target="_blank"
            rel="noopener noreferrer"
          >
            Interested in how this all works?
          </a>
          {` `}
          <a
            href="https://eoinobrien.ie"
            target="_blank"
            rel="noopener noreferrer"
          >
            Created by Eoin O&apos;Brien
          </a>
        </p>
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
