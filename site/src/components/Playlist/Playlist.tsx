import Image from 'next/image';
import { PlaylistComponentProps } from '.';
import styles from './Playlist.module.css';

export const Playlist: React.FC<PlaylistComponentProps> = (
  props: PlaylistComponentProps,
) => {
  return (
    <div className={styles.playlist}>
      <a
        href={'https://open.spotify.com/playlist/' + props.playlist.PlaylistId}
        target="_blank"
        className={styles.spotify}
      >
        <Image
          src={'/cover-art/' + props.playlist.PlaylistTitle + '.jpg'}
          alt={props.playlist.PlaylistTitle}
          width={200}
          height={200}
          className={styles.coverArt}
        />
        <h2 className={styles.spotifyButton}>Play on Spotify</h2>
      </a>
      <a
        href={'https://www.songkick.com/metro-areas/' + props.playlist.MetroId}
        target="_blank"

        className={styles.songkick}
      >
        See concerts on Songkick
      </a>
    </div>
  );
};
